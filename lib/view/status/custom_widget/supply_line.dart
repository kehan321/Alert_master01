import 'package:alert_master1/controller/mqtt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplyLine extends StatelessWidget {
  final TextEditingController dialogcontroller = TextEditingController();

  final MqttController _mqttController = Get.find<MqttController>();
  SupplyLine({
    super.key,
  }) {
    dialogcontroller.text = _mqttController.tempsp3.value.toString();
  }

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
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Supply line",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Set Point Supply"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(
                                  () {
                                    dialogcontroller.text = _mqttController
                                        .tempsp3.value
                                        .toString();
                                    return TextField(
                                      controller: dialogcontroller,
                                      decoration: InputDecoration(
                                        hintText: "Type here...",
                                        border: OutlineInputBorder(),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                    height: 10), // Space before additional text
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _mqttController.supplyLineSetPoint(
                                        dialogcontroller.text);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Save")),
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
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("current temp", style: TextStyle(fontSize: 16)),
                Obx(() => Text("${_mqttController.supplylinetemp.value}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Set Point", style: TextStyle(fontSize: 16)),
                Obx(() => Text("${_mqttController.tempsp3.value}",
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
