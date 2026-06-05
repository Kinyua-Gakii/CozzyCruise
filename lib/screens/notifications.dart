import 'package:flutter/material.dart';
import 'package:cozzy_cruise/utils/responsive.dart';

const Color appYellow = Color(0xFFF6C945);
const Color appBlack = Color(0xFF111111);

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Map<String, bool> notificationSettings;

  @override
  void initState() {
    super.initState();
    notificationSettings = {
      'Trip Requests': true,
      'Promotions': true,
      'Account Updates': true,
      'Earnings Alerts': true,
      'System Notifications': true,
      'News & Tips': false,
    };
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notification Preferences',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ...notificationSettings.entries.map((entry) {
                return notificationTile(entry.key, entry.value, (value) {
                  setState(() {
                    notificationSettings[entry.key] = value ?? false;
                  });
                });
              }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Save Preferences'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget notificationTile(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: appBlack,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: appYellow,
          ),
        ],
      ),
    );
  }
}
