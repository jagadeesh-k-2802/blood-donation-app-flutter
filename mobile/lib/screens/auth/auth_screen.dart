import 'package:flutter/material.dart';
import 'package:blood_donation/screens/auth/login_screen.dart';
import 'package:blood_donation/screens/auth/register_screen.dart';

enum AuthScreenPage { login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthScreenPage currentPage = AuthScreenPage.login;

  void togglePage() {
    setState(() {
      if (currentPage == AuthScreenPage.login) {
        currentPage = AuthScreenPage.register;
      } else {
        currentPage = AuthScreenPage.login;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentPage == AuthScreenPage.login) {
      return LoginScreen(togglePage: togglePage);
    } else {
      return RegisterScreen(togglePage: togglePage);
    }
  }
}
