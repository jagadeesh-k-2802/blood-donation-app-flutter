import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:blood_donation/constants/constants.dart';
import 'package:blood_donation/models/auth.dart';
import 'package:blood_donation/provider/global_state.dart';
import 'package:blood_donation/services/auth.dart';
import 'package:blood_donation/theme/theme.dart';
import 'package:blood_donation/utils/functions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String selectedBloodType = bloodTypes.first;
  List<double> coordinates = List.empty();
  Uint8List? imageBytes;

  Future<void> fetchLocation() async {
    addressController.text = 'Fetching Location...';
    var location = await getCurrentLocation(context);
    coordinates = [location?.$1.latitude ?? 0, location?.$1.longitude ?? 0];
    addressController.text = location?.$2 ?? '';
  }

  Future<void> onAvatarChange() async {
    final ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) {
      return;
    }

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Photo',
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile == null) {
      return;
    }

    try {
      var res = await AuthService.updateAvatar(localFilePath: croppedFile.path);
      imageBytes = await croppedFile.readAsBytes();
      setState(() {});

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> updateUserDetails() async {
    try {
      var res = await AuthService.updateUserDetails(
        name: nameController.text,
        email: emailController.text,
        address: addressController.text,
        coordinates: coordinates,
        bloodType: selectedBloodType,
        phone: phoneController.text,
      );

      if (!mounted) return;
      var userResponse = await AuthService.getMe();

      if (!mounted) return;
      context.read<GlobalState>().setUserResponse(userResponse);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void showLogoutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Do you want to Logout ?'),
            children: <Widget>[
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('NO'),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      logoutUser();
                      Navigator.pop(context);
                    },
                    child: const Text('YES'),
                  ),
                ],
              )
            ],
          );
        });
  }

  Future<void> logoutUser() async {
    try {
      await AuthService.logout();

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/auth', (_) => false);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserResponseData? user = context.watch<GlobalState>().user;

    // Populate Text Fields
    nameController.text = user?.name ?? '';
    emailController.text = user?.email ?? '';
    phoneController.text = user?.phone ?? '';
    addressController.text = user?.address ?? '';
    selectedBloodType = user?.bloodType ?? bloodTypes.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: showLogoutDialog,
            icon: const Icon(Icons.logout),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onAvatarChange,
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: CircleAvatar(
                        radius: 100,
                        child: ClipOval(
                          child: imageBytes == null
                              ? Image.network('$apiUrl/avatar/${user?.avatar}')
                              : Image.memory(imageBytes!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPagePadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32.0),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                      keyboardType: TextInputType.name,
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
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Address',
                        suffixIcon: IconButton(
                          onPressed: fetchLocation,
                          icon: const Icon(Icons.location_on),
                        ),
                      ),
                      keyboardType: TextInputType.streetAddress,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton.icon(
                      onPressed: updateUserDetails,
                      icon: const Icon(Icons.done),
                      label: const Text('Update Details'),
                    ),
                    const SizedBox(height: 4.0),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/change-password');
                      },
                      icon: const Icon(Icons.key),
                      label: const Text('Change Password'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
