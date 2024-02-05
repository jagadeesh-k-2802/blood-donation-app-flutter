import 'package:blood_donation/theme/theme.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: kElevationToShadow[1],
        ),
        child: SizedBox(
          width: 150,
          height: 150,
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 48.0, color: primaryColor),
                const SizedBox(height: 12),
                Text(title, style: textTheme.titleMedium),
                Text(description, style: textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
