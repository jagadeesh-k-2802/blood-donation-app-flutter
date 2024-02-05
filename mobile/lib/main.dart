import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:blood_donation/screens/screens.dart';
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
