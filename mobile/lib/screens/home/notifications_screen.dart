import 'package:blood_donation/screens/home/request_detail_screen.dart';
import 'package:blood_donation/services/blood_request.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:blood_donation/models/notification.dart';
import 'package:blood_donation/services/notification.dart';
import 'package:blood_donation/widgets/bottom_nav_bar.dart';

typedef NotificationItem = GetAllNotificationResponseData;
typedef PagingData = PagingController<int, NotificationItem>;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const pageSize = 20;
  final PagingData pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });

    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await NotificationService.getNotifications(
        page: pageKey,
        limit: pageSize,
      );

      final isLastPage = newItems.data.length < pageSize;

      if (isLastPage) {
        pagingController.appendLastPage(newItems.data);
      } else {
        final nextPageKey = pageKey + newItems.data.length;
        pagingController.appendPage(newItems.data, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future<void> replyToDonateRequest(
    NotificationItem item,
    bool accept,
  ) async {
    try {
      await BloodRequestService.replyToDonateRequest(
        id: item.data ?? '',
        notificationId: item.id,
        accept: accept,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your reply was sent sucessfully')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      pagingController.refresh();
    }
  }

  Widget buildNotificationItem(NotificationItem item) {
    TextTheme textTheme = Theme.of(context).textTheme;

    switch (item.notificationType) {
      case 'donation-request':
        //TODO: View profile of requestor
        //TODO: Send rating on donation completed
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.title),
              Text(item.createdAt.toMoment().ll, style: textTheme.bodySmall),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.description),
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () => replyToDonateRequest(item, true),
                      child: const Text('Accept'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () => replyToDonateRequest(item, false),
                      child: const Text('Reject'),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      case 'donation-accepted':
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.title),
              Text(item.createdAt.toMoment().ll, style: textTheme.bodySmall),
            ],
          ),
          subtitle: Text(item.description),
          onTap: () async {
            await Navigator.pushNamed(
              context,
              '/request-detail',
              arguments: RequestDetailScreenArgs(id: item.data ?? '0'),
            );
          },
        );
      default:
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.title),
              Text(item.createdAt.toMoment().ll, style: textTheme.bodySmall),
            ],
          ),
          subtitle: Text(item.description),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => Future.sync(
            () => pagingController.refresh(),
          ),
          child: PagedListView<int, NotificationItem>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<NotificationItem>(
              itemBuilder: (context, item, index) => buildNotificationItem(
                item,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
