import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:blood_donation/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:blood_donation/screens/screens.dart';
import 'package:blood_donation/theme/theme.dart';
import 'package:blood_donation/provider/global_state.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission(provisional: true);
  FirebaseMessaging.onMessageOpenedApp.listen(notificationHandler);
  FirebaseMessaging.instance.getInitialMessage().then(notificationHandler);
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GlobalState())],
      child: const App(),
    ),
  );
}

Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void notificationHandler(event) {
  if (event?.notification != null) {
    navigatorKey.currentState?.pushNamed('/notifications');
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Donation',
      navigatorKey: navigatorKey,
      theme: bloodDonationAppTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/auth': (_) => const AuthScreen(),
        '/home': (_) => const HomeScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/request-blood': (_) => const RequestBloodScreen(),
        '/request-detail': (_) => const RequestDetailScreen(),
        '/request-edit': (_) => const RequestEditScreen(),
        '/notifications': (_) => const NotificationsScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/change-password': (_) => const ChangePasswordScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/public-profile': (_) => const PublicProfileScreen(),
        '/reviews': (_) => const ReviewsScreen(),
      },
    );
  }
}
