import 'package:flutter/material.dart';

class AlertInfo extends StatelessWidget {
  final String message;
  const AlertInfo({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  const Icon(Icons.info),
                  const SizedBox(width: 6.0),
                  Text('Info:', style: textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(message, style: textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
