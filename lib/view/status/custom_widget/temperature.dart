import 'package:alert_master1/controller/mqtt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class Temperature extends StatelessWidget {
  final TextEditingController dialogcontroller = TextEditingController();

  Temperature({
    super.key,
  }) {
    dialogcontroller.text = _mqttController.tempsp2.value.toString();
  }

  final MqttController _mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.45,
      height: Get.height * 0.18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffb8f7ff),
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
                    "Temperature",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              Obx(() {
                                dialogcontroller.text = _mqttController
                                    .tempsp2.value
                                    .toString(); // ✅ Update value dynamically
                                return TextField(
                                  controller: dialogcontroller,
                                  decoration: InputDecoration(
                                    hintText: "Type here...",
                                    border: OutlineInputBorder(),
                                  ),
                                );
                              }),
                              const SizedBox(height: 10),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _mqttController
                                    .setTemperature(dialogcontroller.text);
                                Navigator.pop(context);
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Icon(Icons.settings, size: 30),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Suc.Lin.Temp", style: TextStyle(fontSize: 16)),
                Obx(() => Text(
                      "${_mqttController.suctionlinetemp.value}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Set Point", style: TextStyle(fontSize: 16)),
                Obx(() => Text(
                      "${_mqttController.tempsp2.value}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
