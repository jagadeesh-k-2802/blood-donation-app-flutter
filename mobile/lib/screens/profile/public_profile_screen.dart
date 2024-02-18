import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/services/user.dart';
import 'package:blood_donation/theme/theme.dart';
import 'package:blood_donation/constants/constants.dart';

class PublicProfileScreenArgs {
  final String id;
  PublicProfileScreenArgs({required this.id});
}

class PublicProfileScreen extends StatefulWidget {
  const PublicProfileScreen({super.key});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  GetProfileResponseData? data;
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    final settings = ModalRoute.of(context)!.settings;
    final args = settings.arguments as PublicProfileScreenArgs;

    try {
      setState(() => loading = true);
      var res = await UserService.getProfile(id: args.id);
      setState(() => data = res.data);
    } catch (e) {
      setState(() => error = true);
    } finally {
      setState(() => loading = false);
    }
  }

  Widget buildReviewItem(ProfileReviewData? reviewData) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListTile(
      title: Text('${reviewData?.createdBy.name} Says'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(reviewData?.review ?? ''),
          const SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                reviewData?.rating.toString() ?? '',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(width: 5.0),
              const Icon(Icons.star),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLoadingWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator()),
        )
      ],
    );
  }

  Widget buildErrorWidget() {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 64),
          const SizedBox(height: 8.0),
          Text('Something Went Wrong', style: textTheme.titleLarge),
          const SizedBox(height: 12.0),
          ElevatedButton.icon(
            onPressed: fetchData,
            icon: const Icon(Icons.replay_outlined),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget buildDetailWidget() {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: CircleAvatar(
                radius: 100,
                child: ClipOval(
                  child: Image.network('$apiUrl/avatar/${data?.avatar}'),
                ),
              ),
            ),
            Text(
              data?.name ?? '',
              style: textTheme.displaySmall,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        const SizedBox(height: 16.0),
        InkWell(
          onTap: () async {
            await launchUrl(Uri.parse('tel:${data?.phone}'));
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: ListTile(
              leading: const Icon(Icons.phone, color: primaryColor),
              title: Text(data?.phone ?? ''),
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: ListTile(
            leading: const Icon(Icons.email, color: primaryColor),
            title: Text(data?.email ?? ''),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: ListTile(
            leading: const Icon(Icons.location_on, color: primaryColor),
            title: Text(data?.address ?? ''),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: ListTile(
            leading: const Icon(Icons.bloodtype, color: primaryColor),
            title: Text(data?.bloodType ?? ''),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: ListTile(
            leading: const Icon(Icons.healing_sharp, color: primaryColor),
            title: Text('Total Donations: ${data?.totalDonated}'),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: ListTile(
            leading: const Icon(Icons.star, color: primaryColor),
            title: Text('Average Rating: ${data?.averageRating}'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
          child: Row(
            children: [
              Text(
                'User Reviews',
                style: textTheme.titleLarge,
              ),
              const SizedBox(width: 8.0),
              const Icon(Icons.reviews_outlined),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await fetchData(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverAppBar(),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPagePadding,
                      ),
                      child: Column(
                        children: [
                          Visibility(
                            visible: loading && !error && data == null,
                            child: buildLoadingWidget(),
                          ),
                          Visibility(
                            visible: error && !loading,
                            child: buildErrorWidget(),
                          ),
                          Visibility(
                            visible: data != null && !loading,
                            child: buildDetailWidget(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverList.separated(
                itemCount: data?.reviews.length ?? 0,
                itemBuilder: (context, index) {
                  return buildReviewItem(data?.reviews[index]);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
