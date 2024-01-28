import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:blood_donation/utils/functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await hasInternetConnection()) {
        if (mounted) {
          FlutterNativeSplash.remove();
          authNavigate(context);
        }
      } else {
        FlutterNativeSplash.remove();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No Internet Connection'),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                },
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: null);
  }
}
