import 'package:blood_donation/services/blood_request.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation/widgets/bottom_nav_bar.dart';
import 'package:blood_donation/constants/constants.dart';
import 'package:blood_donation/theme/theme.dart';
import 'package:blood_donation/utils/functions.dart';

class RequestBloodScreen extends StatefulWidget {
  const RequestBloodScreen({super.key});

  @override
  State<RequestBloodScreen> createState() => _RequestBloodScreenState();
}

class _RequestBloodScreenState extends State<RequestBloodScreen> {
  TextEditingController patientNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController unitsController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  String selectedBloodType = bloodTypes.first;
  List<double> coordinates = List.empty();

  Future<void> fetchLocation() async {
    locationController.text = 'Fetching Location...';
    var location = await getCurrentLocation(context);
    coordinates = [location?.$1.latitude ?? 0, location?.$1.longitude ?? 0];
    locationController.text = location?.$2 ?? '';
  }

  Future<void> sendBloodRequest() async {
    try {
      var res = await BloodRequestService.createBloodRequest(
        patientName: patientNameController.text,
        age: ageController.text,
        bloodType: selectedBloodType,
        location: locationController.text,
        coordinates: coordinates,
        contactNumber: contactController.text,
        unitsRequired: int.parse(unitsController.text),
        notes: notesController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message)),
      );

      // Clear All Values
      setState(() {
        patientNameController.text = '';
        ageController.text = '';
        locationController.text = '';
        contactController.text = '';
        unitsController.text = '';
        notesController.text = '';
      });

      // TODO: Navigate to Detail Screen
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add Time Until TextField

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Blood'),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPagePadding),
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              TextFormField(
                controller: patientNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Patient Name',
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Age',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Blood Group',
                ),
                value: selectedBloodType,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                onChanged: (String? value) {
                  setState(() {
                    selectedBloodType = value!;
                  });
                },
                items: bloodTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Hospital Location',
                  suffixIcon: IconButton(
                    onPressed: fetchLocation,
                    icon: const Icon(Icons.location_on),
                  ),
                ),
                keyboardType: TextInputType.streetAddress,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contact Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: unitsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Units Required',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                minLines: 2,
                maxLines: 2,
                controller: notesController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Notes',
                ),
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: sendBloodRequest,
                icon: const Icon(Icons.bloodtype),
                label: const Text('Request Blood'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
