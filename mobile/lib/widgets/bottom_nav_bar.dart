import 'package:blood_donation/services/notification.dart';
import 'package:blood_donation/theme/theme.dart';
import 'package:flutter/material.dart';

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

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (_) => false,
        );
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (_) => false,
        );
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/request-blood',
          (_) => false,
        );
        break;
      case 3:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/notifications',
          (_) => false,
        );
        break;
      case 4:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/profile',
          (_) => false,
        );
        break;
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
