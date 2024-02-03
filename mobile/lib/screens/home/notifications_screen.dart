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
              itemBuilder: (context, item, index) => ListTile(
                title: Text(item.title),
                subtitle: Text(item.description),
                trailing: Column(
                  children: [Text(item.createdAt.toMoment().lll)],
                ),
                onTap: () {
                  // TODO: Navigate to right desination on Notification Tap
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
