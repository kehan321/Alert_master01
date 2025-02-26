import 'package:alert_master1/controller/status_controller/info_card/info_card_controller.dart'
    show InfoController5;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OilPressure extends StatelessWidget {
  final TextEditingController dialogcontroller = TextEditingController();
  final InfoController5 controller =
      Get.put(InfoController5()); // Inject GetX controller

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.45, // 90% of screen width
      height: Get.height * 0.18, // Fixed height

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Color(0xffb8f7ff)),
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
                                title: const Text("Oil Pressure"),
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
                                    onPressed: () => Navigator.pop(context),
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
                Obx(() => Text(controller.subText1.value,
                    style: TextStyle(fontSize: 16))),
                Obx(() => Text("${controller.value1.value}",
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
