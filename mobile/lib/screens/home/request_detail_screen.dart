import 'package:blood_donation/widgets/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blood_donation/utils/functions.dart';
import 'package:blood_donation/constants/constants.dart';
import 'package:blood_donation/models/auth.dart';
import 'package:blood_donation/provider/global_state.dart';
import 'package:blood_donation/screens/screens.dart';
import 'package:blood_donation/theme/theme.dart';
import 'package:blood_donation/models/blood_request.dart';
import 'package:blood_donation/services/blood_request.dart';

class RequestDetailScreenArgs {
  final String id;
  RequestDetailScreenArgs({required this.id});
}

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({super.key});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  GetBloodRequestResponseData? data;
  bool loading = true;
  bool error = false;
  bool requestProcessing = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    final settings = ModalRoute.of(context)!.settings;
    final args = settings.arguments as RequestDetailScreenArgs;

    try {
      setState(() => loading = true);
      var res = await BloodRequestService.getBloodRequest(id: args.id);
      setState(() => data = res.data);
    } catch (e) {
      setState(() => error = true);
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> goToEditScreen() async {
    if (data == null) return;

    await Navigator.pushNamed(
      context,
      '/request-edit',
      arguments: RequestEditScreenArgs(data: data!),
    );

    await fetchData();
  }

  Future<void> markRequestAsCompleted() async {
    setState(() => requestProcessing = true);

    try {
      var location = await getCurrentLocation(context);

      var coordinates = [
        location?.$1.latitude ?? 0,
        location?.$1.longitude ?? 0,
      ];

      await BloodRequestService.markRequestCompleted(
        id: data?.id ?? '',
        coordinates: coordinates,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completed Succesfully')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => requestProcessing = false);
      await fetchData();
    }
  }

  Future<void> sendDonateRequest() async {
    try {
      await BloodRequestService.sendDonateRequest(id: data?.id ?? '');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donate Request Sent')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      await fetchData();
    }
  }

  Future<void> deleteBloodRequest() async {
    try {
      await BloodRequestService.deleteRequest(id: data?.id ?? '');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request Deleted Sucessfully')),
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
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
    UserResponseData? user = context.read<GlobalState>().user;
    bool isOwner = user?.id == data?.createdBy.id;
    bool isDonator = user?.id == data?.acceptedBy?.id;
    bool isDonationAccepted = isDonator && data?.status == 'accepted';
    bool isDonationCompleted = isDonator && data?.status == 'completed';
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Request Posted By', style: textTheme.titleLarge),
        const SizedBox(height: 12.0),
        Row(
          children: [
            SizedBox(
              width: 64.0,
              height: 64.0,
              child: CircleAvatar(
                radius: 100,
                child: ClipOval(
                  child: Image.network(
                    '$apiUrl/avatar/${data?.createdBy.avatar}',
                    errorBuilder: (context, obj, stacktrace) {
                      return Container();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              data?.createdBy.name ?? '',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(width: 12.0),
          ],
        ),
        const SizedBox(height: 16.0),
        Visibility(
          visible: isOwner && data?.status == 'completed',
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/public-profile',
                    arguments: PublicProfileScreenArgs(
                      id: data?.acceptedBy?.id ?? '',
                    ),
                  );
                },
                child: AlertInfo(
                  message:
                      'Your request has been succesfully served by ${data?.acceptedBy?.name}',
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
        Visibility(
          visible: isDonationCompleted,
          child: const Column(
            children: [
              AlertInfo(
                message:
                    'You have completed this donation. Thanks for your co-operation',
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
        Visibility(
          visible: isOwner && data?.status == 'accepted',
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/public-profile',
                    arguments: PublicProfileScreenArgs(
                      id: data?.acceptedBy?.id ?? '',
                    ),
                  );
                },
                child: AlertInfo(
                  message:
                      'Your request has been accepted by ${data?.acceptedBy?.name}. contact them by tapping this message.',
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
        Visibility(
          visible: isDonationAccepted && !isOwner,
          child: const Column(
            children: [
              AlertInfo(
                message:
                    'Your request has been accepted, contact them by tapping the contact number and kindly be as soon as possible. Tap \'Completed\' after your donation has been completed right in the hospital. Thank You',
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
        Text(
          'Patient Name: ${data?.patientName}',
          style: textTheme.bodyLarge,
        ),
        Text(
          'Age: ${data?.age}',
          style: textTheme.bodyLarge,
        ),
        Text(
          'Blood Group: ${data?.bloodType}',
          style: textTheme.bodyLarge,
        ),
        Text(
          'Units Required: ${data?.unitsRequired}',
          style: textTheme.bodyLarge,
        ),
        Text(
          'Location: ${data?.location}',
          style: textTheme.bodyLarge,
        ),
        Visibility(
          visible: isDonationAccepted,
          child: GestureDetector(
            onTap: () async {
              await launchUrl(Uri.parse('tel:${data?.contactNumber}'));
            },
            child: Text('Contact Number: ${data?.contactNumber}',
                style: textTheme.bodyLarge),
          ),
        ),
        Text(
          'Notes: ${data?.notes?.isEmpty == true ? '--' : data?.notes}',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                data?.locationCoordinates[1] ?? 50,
                data?.locationCoordinates[0] ?? 30,
              ),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                tileProvider: CancellableNetworkTileProvider(),
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      data?.locationCoordinates[1] ?? 50,
                      data?.locationCoordinates[0] ?? 30,
                    ),
                    width: 48,
                    height: 48,
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      onPressed: () async {
                        String url = 'https://maps.google.com/maps?q=';
                        url += '${data?.locationCoordinates[1]},';
                        url += '${data?.locationCoordinates[0]}';
                        await launchUrl(Uri.parse(url));
                      },
                      icon: const Icon(
                        Icons.location_on,
                        size: 48,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Visibility(
          visible: !isOwner && !isDonationAccepted,
          child: ElevatedButton.icon(
            onPressed: isDonator ? null : sendDonateRequest,
            icon: Icon(
              isDonator ? Icons.done : Icons.bloodtype,
            ),
            label: Text(
              isDonator ? 'Donate Request Sent' : 'Send Donate Request',
            ),
          ),
        ),
        Visibility(
          visible: isDonationAccepted && !isOwner,
          child: ElevatedButton.icon(
            onPressed: requestProcessing ? null : markRequestAsCompleted,
            icon: const Icon(Icons.done),
            label: Text(
              requestProcessing ? 'Please Wait...' : 'Mark as Completed',
            ),
          ),
        ),
        Visibility(
          visible: isOwner && data?.status != 'completed',
          child: ElevatedButton.icon(
            onPressed: deleteBloodRequest,
            icon: const Icon(Icons.delete),
            label: const Text('Delete Blood Request'),
          ),
        ),
        const SizedBox(height: 64)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    UserResponseData? user = context.read<GlobalState>().user;
    bool isOwner = user?.id == data?.createdBy.id;
    List<Widget> actions = [];

    if (isOwner) {
      actions.add(
        IconButton(
          onPressed: goToEditScreen,
          icon: const Icon(Icons.edit),
          tooltip: 'Edit',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(actions: actions),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await fetchData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
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
          ),
        ),
      ),
    );
  }
}
