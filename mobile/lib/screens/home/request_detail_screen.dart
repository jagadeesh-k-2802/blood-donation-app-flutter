import 'package:flutter/material.dart';
import 'package:blood_donation/constants/constants.dart';
import 'package:blood_donation/models/auth.dart';
import 'package:blood_donation/provider/global_state.dart';
import 'package:blood_donation/screens/screens.dart';
import 'package:blood_donation/theme/theme.dart';
import 'package:blood_donation/models/blood_request.dart';
import 'package:blood_donation/services/blood_request.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

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

  Future<void> sendDonateRequest() async {
    // TODO: sendDonateRequest
  }

  Future<void> deleteBloodRequest() async {
    // TODO: deleteBloodRequest
  }

  Widget buildLoadingWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [Center(child: CircularProgressIndicator())],
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
        const SizedBox(height: 32.0),
        // TODO: Show Contact Number only when accepted
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
              // TODO: Open Google Maps with Coordinates
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
                    alignment: Alignment.centerLeft,
                    child: const Icon(
                      Icons.location_pin,
                      color: primaryColor,
                      size: 48,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Visibility(
          visible: !isOwner,
          child: ElevatedButton.icon(
            onPressed: sendDonateRequest,
            icon: const Icon(Icons.bloodtype),
            label: const Text('Send Donate Request'),
          ),
        ),
        Visibility(
          visible: isOwner,
          child: ElevatedButton.icon(
            onPressed: deleteBloodRequest,
            icon: const Icon(Icons.delete),
            label: const Text('Delete Blood Request'),
          ),
        ),
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
                  Visibility(visible: loading, child: buildLoadingWidget()),
                  Visibility(visible: error, child: buildErrorWidget()),
                  Visibility(visible: data != null, child: buildDetailWidget()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
