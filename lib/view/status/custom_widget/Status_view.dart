import 'dart:async';

import 'package:alert_master1/controller/mqtt_controller.dart';
import 'package:alert_master1/view/status/custom_widget/temp.dart';
import 'package:alert_master1/view/status/notification.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusScreen extends StatefulWidget {
  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final MqttController _mqttController = Get.put(MqttController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Alert Master",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(
                Icons.notification_important_outlined,
                size: 26,
                color: _mqttController.isConnected.value
                    ? Colors.green
                    : Colors.red,
              ),
              onPressed: () {
                Get.to(NotificationPage());
              },
            );
          }),
          Obx(() {
            return IconButton(
              icon: Icon(
                Icons.settings,
                size: 26,
                color: _mqttController.isConnected.value
                    ? Colors.green
                    : Colors.red,
              ),
              onPressed: () {},
            );
          }),
        ],
      ),
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.black87,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => GestureDetector(
                    onTap: () => _mqttController.toggleStatus(),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        width: screenWidth * 0.92,
                        height: screenHeight * 0.09,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black87,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Compressor ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(width: screenWidth * 0.35),
                            Container(
                              width: screenWidth * 0.18,
                              height: screenHeight * 0.05,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _mqttController.comprsw.value == 1
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _mqttController.comprsw.value == 1
                                    ? "ON"
                                    : "OFF",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 10),
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0), child: Temperature()),
                  SizedBox(height: 5),
                  Padding(
                      padding: const EdgeInsets.all(8.0), child: Pressure()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
