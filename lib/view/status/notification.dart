import 'package:alert_master1/controller/mqtt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final MqttController _mqttController = Get.find<MqttController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mqttController.checkAndStoreValues();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Clear all notifications
              setState(() {
                _mqttController.deleteAllAlerts();
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: Obx(() {
        var reversedNotifications =
            List.from(_mqttController.valueHistory.reversed);
        var lastThreeNotifications = reversedNotifications.take(9).toList();

        if (lastThreeNotifications.isEmpty) {
          return Center(
            child: Text(
              'No notifications available.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: lastThreeNotifications.length,
          itemBuilder: (context, index) {
            var record = lastThreeNotifications[index];
            var timestamp = record.timestamp.toLocal().toString().split('.')[0];

            return Dismissible(
              key: Key(record.timestamp.toString()),
              onDismissed: (direction) {
                setState(() {
                  _mqttController.deleteAlert(record.name);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${record.name} alert deleted")));
              },
              background: Container(color: Colors.red),
              child: Card(
                color: record.isRead
                    ? Colors.greenAccent.withOpacity(0.8)
                    : Colors.redAccent.withOpacity(0.8),
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    record.isRead
                        ? Icons.check_circle
                        : Icons.warning_amber_rounded,
                    color: Colors.white,
                  ),
                  title: Text(
                    "${record.name} Temperature: ${record.value}",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "Timestamp: $timestamp",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.mark_email_read, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        record.isRead = true;
                      });
                    },
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
