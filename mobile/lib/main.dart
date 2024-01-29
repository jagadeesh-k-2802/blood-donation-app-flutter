import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:blood_donation/screens/auth/auth_screen.dart';
import 'package:blood_donation/screens/home/home_screen.dart';
import 'package:blood_donation/screens/splash_screen.dart';
import 'package:blood_donation/screens/home/dashboard_screen.dart';
import 'package:blood_donation/screens/home/notifications_screen.dart';
import 'package:blood_donation/screens/home/profile_screen.dart';
import 'package:blood_donation/screens/home/request_blood_screen.dart';
import 'package:blood_donation/screens/auth/forgot_password_screen.dart';
import 'package:blood_donation/screens/auth/change_password_screen.dart';
import 'package:blood_donation/theme/theme.dart';
import 'package:blood_donation/provider/global_state.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GlobalState())],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Donation',
      theme: bloodDonationAppTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/request-blood': (context) => const RequestBloodScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
    );
  }
}
