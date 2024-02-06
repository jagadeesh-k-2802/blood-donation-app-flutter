import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:blood_donation/services/auth.dart';
import 'package:blood_donation/utils/functions.dart';
import 'package:blood_donation/theme/theme.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback togglePage;
  const LoginScreen({super.key, required this.togglePage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;

  Future<void> sendLoginRequest() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';

      await AuthService.login(
        email: emailController.text,
        password: passwordController.text,
        fcmToken: fcmToken,
      );

      if (mounted) {
        authNavigate(context);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(color: primaryColor),
                width: double.infinity,
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Give Hope, Give Life. Donate Blood',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineLarge?.apply(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPagePadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: textTheme.displaySmall,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'LOGIN',
                      style: textTheme.displaySmall?.apply(color: primaryColor),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 32.0),
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
                      controller: passwordController,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: const ButtonStyle(
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(0)),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(color: Colors.black54),
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    ElevatedButton.icon(
                      onPressed: sendLoginRequest,
                      icon: const Icon(Icons.done),
                      label: const Text('Login'),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: widget.togglePage,
                      child: Text(
                        'New User ? Register',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
