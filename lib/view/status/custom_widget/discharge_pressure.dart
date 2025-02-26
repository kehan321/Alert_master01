import 'package:alert_master1/controller/mqtt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DischargePressure extends StatelessWidget {
  final TextEditingController dialogcontroller = TextEditingController();
  final MqttController _mqttController = Get.find<MqttController>();

  DischargePressure({
    super.key,
  }) {
    dialogcontroller.text = _mqttController.pressuresp1.value.toString();
  } // Inject GetX controller

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.45, // 90% of screen width
      height: Get.height * 0.18, // Fixed height
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffb8f7ff), // Background color
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Discharge",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Discharge Pressure"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Text before the TextField
                              Obx(
                                () {
                                  dialogcontroller.text = _mqttController
                                      .pressuresp1.value
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
                                _mqttController.dischargePressureSetPoint(
                                    dialogcontroller.text);
                                Navigator.pop(context);
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Icon(Icons.settings))
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("current psi", style: TextStyle(fontSize: 16)),
              Obx(() => Text("${_mqttController.dischargepressure.value}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Set psi", style: TextStyle(fontSize: 16)),
              Obx(() => Text("${_mqttController.pressuresp1.value}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
