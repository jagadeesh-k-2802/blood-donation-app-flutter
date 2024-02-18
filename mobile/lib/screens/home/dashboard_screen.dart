import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:blood_donation/models/auth.dart';
import 'package:blood_donation/provider/global_state.dart';
import 'package:blood_donation/screens/home/request_detail_screen.dart';
import 'package:blood_donation/services/blood_request.dart';
import 'package:blood_donation/utils/functions.dart';
import 'package:blood_donation/models/blood_request.dart';

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

  MaterialColor getColorForStatus(String status) {
    switch (status) {
      case 'active':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'accepted':
      case 'completed':
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  Widget buildListItem(BloodRequestItem item) {
    return ListTile(
      title: Text(item.patientName),
      subtitle: Text(
        item.location,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        children: [
          Text(
            titleCase(item.status),
            style: TextStyle(color: getColorForStatus(item.status)),
          ),
        ],
      ),
      onTap: () async {
        await Navigator.pushNamed(
          context,
          '/request-detail',
          arguments: RequestDetailScreenArgs(id: item.id),
        );

        pagingController.refresh();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserResponseData? user = context.read<GlobalState>().user;

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
        body: SafeArea(
          child: TabBarView(
            children: <Widget>[
              RefreshIndicator(
                onRefresh: () => Future.sync(
                  () => pagingController.refresh(),
                ),
                child: PagedListView<int, BloodRequestItem>(
                  pagingController: pagingController,
                  builderDelegate: PagedChildBuilderDelegate<BloodRequestItem>(
                    itemBuilder: (context, item, index) {
                      return item.createdBy != user?.id
                          ? Container()
                          : buildListItem(item);
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
                    return item.acceptedBy != user?.id
                        ? Container()
                        : buildListItem(item);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
