import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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
      Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
    }
  }
}
