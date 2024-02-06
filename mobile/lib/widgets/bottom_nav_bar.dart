import 'package:flutter/material.dart';
import 'package:blood_donation/services/notification.dart';
import 'package:blood_donation/theme/theme.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int notificationsUnreadCount = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchUnreadCount();
    });
  }

  Future<void> fetchUnreadCount() async {
    try {
      var res = await NotificationService.getUnreadCount();

      setState(() {
        notificationsUnreadCount = res.data.count;
      });
    } catch (e) {
      // Do Nothing
    }
  }

  void onDestinationSelected(int index) {
    if (widget.currentIndex == index) {
      return;
    }

    String? route;

    switch (index) {
      case 0:
        route = '/home';
        break;
      case 1:
        route = '/dashboard';
        break;
      case 2:
        route = '/request-blood';
        break;
      case 3:
        route = '/notifications';
        break;
      case 4:
        route = '/profile';
        break;
    }

    if (route != null) {
      Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: onDestinationSelected,
      indicatorColor: primaryColor,
      selectedIndex: widget.currentIndex,
      destinations: <Widget>[
        const NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        const NavigationDestination(
          selectedIcon: Icon(Icons.dashboard),
          icon: Icon(Icons.dashboard_outlined),
          label: 'Dashboard',
        ),
        const NavigationDestination(
          selectedIcon: Icon(Icons.bloodtype),
          icon: Icon(Icons.bloodtype_outlined),
          label: 'Ask Blood',
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.notifications),
          icon: notificationsUnreadCount > 0
              ? Badge.count(
                  count: notificationsUnreadCount,
                  child: const Icon(Icons.notifications_outlined),
                )
              : const Icon(Icons.notifications_outlined),
          label: 'Notifications',
        ),
        const NavigationDestination(
          selectedIcon: Icon(Icons.account_box),
          icon: Icon(Icons.account_box_outlined),
          label: 'Profile',
        ),
      ],
    );
  }
}
