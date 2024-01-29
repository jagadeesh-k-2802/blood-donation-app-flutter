import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:blood_donation/provider/global_state.dart';
import 'package:blood_donation/services/auth.dart';

Future<bool> hasInternetConnection() async {
  return await InternetConnectionChecker().hasConnection;
}

/// authNavigate
/// * Navigates to the right destination based on current state of The Application
///
Future<void> authNavigate(BuildContext context) async {
  try {
    final userResponse = await AuthService.getMe();

    if (context.mounted) {
      context.read<GlobalState>().setUserResponse(userResponse);
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.sendTimeout) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot Connect To Server')),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/auth', (_) => false);
    }
  }
}

/// getCurrentLocation
/// * Fetches the current location of the user
///
Future<String?> getCurrentLocation(BuildContext context) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  LocationPermission permission = await Geolocator.checkPermission();

  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      if (!context.mounted) return '';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Text('Please Enable Location Permission');
        },
      );

      return '';
    }
  }

  if (permission == LocationPermission.deniedForever) {
    if (!context.mounted) return '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Text('Please Enable Location Permission');
      },
    );

    return '';
  }

  Position position = await Geolocator.getCurrentPosition();

  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  String geoCodeLoation = '';

  if (placemarks.isNotEmpty) {
    geoCodeLoation += '${placemarks[0].street} ';
    geoCodeLoation += '${placemarks[0].subLocality} ';
    geoCodeLoation += '${placemarks[0].locality} ';
    geoCodeLoation += '${placemarks[0].postalCode} ';
    geoCodeLoation += '${placemarks[0].country} ';
  }

  return geoCodeLoation;
}
