import 'package:flutter/material.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification"), backgroundColor: MainColor),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          height: bodyHeight(context),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildNotificationList(),
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        _buildNotificationItem(
          Icons.event,
          "New session was added",
          "3/7/2025, 6:00 PM",
          "1m ago",
        ),
        _buildNotificationItem(
          Icons.warning,
          "Warning",
          "You lost two stars this month.",
          "2m ago",
        ),
        _buildNotificationItem(
          Icons.warning,
          "Warning",
          "You lost one star this month.",
          "1 week ago",
        ),
      ],
    );
  }

  Widget _buildNotificationItem(
    IconData icon,
    String title,
    String subtitle,
    String time,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: MainColor, size: 32),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: Text(time, style: TextStyle(color: Colors.grey)),
        ),
        Divider(),
      ],
    );
  }
}
