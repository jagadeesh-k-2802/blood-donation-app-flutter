import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:blood_donation/screens/profile/public_profile_screen.dart';
import 'package:blood_donation/screens/home/request_detail_screen.dart';
import 'package:blood_donation/services/blood_request.dart';
import 'package:blood_donation/models/notification.dart';
import 'package:blood_donation/services/notification.dart';

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
        id: item.itemId ?? '',
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

  Future<void> sendUserReview(
    String itemId,
    String notificationId,
    double rating,
    String review,
  ) async {
    try {
      var res = await BloodRequestService.sendRating(
        id: itemId,
        rating: rating,
        review: review,
        notificationId: notificationId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message)),
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

  void showRatingDialog(String itemId, String notificationId) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        double rating = 3;
        TextEditingController reviewController = TextEditingController();

        return Dialog(
          child: SizedBox(
            height: 335,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Rate Your Experience',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16.0),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (val) {
                      setState(() => rating = val);
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: reviewController,
                      minLines: 3,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Review',
                      ),
                      validator: (String? val) {
                        if (val?.isEmpty == true) return 'Please enter review';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        Navigator.pop(context);

                        sendUserReview(
                          itemId,
                          notificationId,
                          rating,
                          reviewController.text,
                        );
                      }
                    },
                    icon: const Icon(Icons.done),
                    label: const Text('Submit'),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildNotificationItem(NotificationItem item) {
    TextTheme textTheme = Theme.of(context).textTheme;

    switch (item.notificationType) {
      case 'donation-request':
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
          onTap: () {
            Navigator.pushNamed(
              context,
              '/public-profile',
              arguments: PublicProfileScreenArgs(
                id: item.profileId ?? '',
              ),
            );
          },
        );
      case 'nearby-donation-request':
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
              arguments: RequestDetailScreenArgs(id: item.itemId ?? '0'),
            );
          },
        );
      case 'donation-completed':
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
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () => showRatingDialog(
                        item.itemId ?? '',
                        item.id,
                      ),
                      child: const Text('Send Rating'),
                    ),
                  ),
                ],
              )
            ],
          ),
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
