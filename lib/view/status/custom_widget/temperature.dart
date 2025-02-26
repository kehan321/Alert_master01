import 'dart:developer';

import 'package:alert_master1/controller/mqtt_controller.dart';
import 'package:alert_master1/controller/status_controller/info_card/info_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Temperature extends StatelessWidget {
  final String data;
  late final TextEditingController dialogcontroller;

  Temperature({super.key, required this.data}) {
    dialogcontroller = TextEditingController(text: data);
  }
  final InfoController controller = Get.put(InfoController());
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.45, // 90% of screen width
      height: Get.height * 0.18, // Fixed height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffb8f7ff), // Background color
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(() => Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.title.value,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Set Point Temperature"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Text before the TextField
                                    TextField(
                                      controller: dialogcontroller,
                                      decoration: InputDecoration(
                                        hintText: "Type here...",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            10), // Space before additional text
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // _mqttController.setTemperature(
                                      //     dialogcontroller.text);

                                      Navigator.pop(context);
                                    },
                                    child: const Text("Save"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Icon(
                            Icons.settings,
                            size: 30,
                          ))
                    ],
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Suc.Lin.Temp",
                  style: TextStyle(fontSize: 16),
                ),
                Obx(() => Text("${_mqttController.dxstate.value}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(controller.subText2.value,
                    style: TextStyle(fontSize: 16))),
                Obx(() => Text("${controller.value2.value}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
