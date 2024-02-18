import 'package:flutter/material.dart';
import 'package:blood_donation/screens/screens.dart';
import 'package:blood_donation/services/notification.dart';
import 'package:blood_donation/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int notificationsUnreadCount = 0;
  int currentIndex = 0;

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
      setState(() => notificationsUnreadCount = res.data.count);
    } catch (e) {
      // Do Nothing
    }
  }

  void onDestinationSelected(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          FeedScreen(),
          DashboardScreen(),
          RequestBloodScreen(),
          NotificationsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: onDestinationSelected,
        indicatorColor: primaryColor,
        selectedIndex: currentIndex,
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
      ),
    );
  }
}
