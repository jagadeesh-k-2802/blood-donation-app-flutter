import 'package:flutter/material.dart';
import 'package:blood_donation/services/auth.dart';
import 'package:blood_donation/theme/theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController tokenController = TextEditingController();
  bool showResetTextField = false;
  bool hidePassword = true;

  Future<void> sendForgotPasswordRequest() async {
    try {
      var res = await AuthService.forgotPassword(email: emailController.text);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message)),
      );

      setState(() {
        showResetTextField = true;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> resetPassword() async {
    try {
      var res = await AuthService.resetPassword(
        token: tokenController.text,
        password: passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message)),
      );

      Navigator.pop(context);
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
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPagePadding),
          child: Column(
            children: [
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
              Text(
                'Enter your registered Email ID and submit you will recieve an mail with OTP from us.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 16.0),
              Visibility(
                visible: showResetTextField,
                child: Column(
                  children: [
                    TextFormField(
                      controller: tokenController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'OTP',
                        hintText: 'Enter OTP',
                      ),
                      keyboardType: TextInputType.text,
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
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: showResetTextField
                    ? resetPassword
                    : sendForgotPasswordRequest,
                icon: const Icon(Icons.done),
                label: Text(showResetTextField ? 'Reset Password' : 'Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
