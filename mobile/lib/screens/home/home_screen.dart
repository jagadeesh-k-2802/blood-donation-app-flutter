import 'package:blood_donation/models/auth.dart';
import 'package:blood_donation/provider/global_state.dart';
import 'package:blood_donation/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    UserResponseData? user = context.read<GlobalState>().user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user?.name}'),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: null,
    );
  }
}
