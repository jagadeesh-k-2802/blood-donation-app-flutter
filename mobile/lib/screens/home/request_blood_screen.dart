import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:blood_donation/screens/home/request_detail_screen.dart';
import 'package:blood_donation/services/blood_request.dart';
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
  TextEditingController timeUntilController = TextEditingController();
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
        timeUntil: timeUntilController.text,
        notes: notesController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request Created Sucessfully')),
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

      Navigator.pushNamed(
        context,
        '/request-detail',
        arguments: RequestDetailScreenArgs(id: res.data.id),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> chooseTimeUntil() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (selectedDate != null && mounted) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          timeUntilController.text = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          ).toMoment().LLL;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Blood'),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      body: SafeArea(
        child: SingleChildScrollView(
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
                  onTap: chooseTimeUntil,
                  readOnly: true,
                  controller: timeUntilController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Time Until',
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
                const SizedBox(height: 24.0),
                ElevatedButton.icon(
                  onPressed: sendBloodRequest,
                  icon: const Icon(Icons.bloodtype),
                  label: const Text('Request Blood'),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
