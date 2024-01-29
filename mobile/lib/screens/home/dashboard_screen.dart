import 'package:blood_donation/models/auth.dart';
import 'package:blood_donation/provider/global_state.dart';
import 'package:blood_donation/services/blood_request.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:blood_donation/models/blood_request.dart';
import 'package:blood_donation/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef BloodRequestItem = GetAllBloodRequestResponseData;
typedef PagingData = PagingController<int, BloodRequestItem>;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
      final newItems = await BloodRequestService.getBloodRequests(
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
    UserResponseData? user = context.read<GlobalState>().user;

    // TODO: Show status of the request
    // TODO: Navigate to Detail Screen on List Item Tap

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget>[
              Tab(text: 'Requested'),
              Tab(text: 'Donated'),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 1),
        body: TabBarView(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: () => Future.sync(
                () => pagingController.refresh(),
              ),
              child: PagedListView<int, BloodRequestItem>(
                pagingController: pagingController,
                builderDelegate: PagedChildBuilderDelegate<BloodRequestItem>(
                  itemBuilder: (context, item, index) {
                    if (item.createdBy != user?.id) {
                      return Container();
                    }

                    return ListTile(
                      title: Text(item.patientName),
                      subtitle: Text(item.location),
                    );
                  },
                ),
              ),
            ),
            RefreshIndicator(
              onRefresh: () => Future.sync(
                () => pagingController.refresh(),
              ),
              child: PagedListView<int, BloodRequestItem>(
                pagingController: pagingController,
                builderDelegate: PagedChildBuilderDelegate<BloodRequestItem>(
                    itemBuilder: (context, item, index) {
                  if (item.acceptedBy != user?.id) {
                    return Container();
                  }

                  return ListTile(
                    title: Text(item.patientName),
                    subtitle: Text(item.location),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
