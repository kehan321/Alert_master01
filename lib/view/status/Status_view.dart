import 'package:alert_master1/controller/mqtt_controller.dart';
import 'package:alert_master1/view/status/custom_widget/temperature.dart';
import 'package:alert_master1/view/status/custom_widget/discharge.dart';
import 'package:alert_master1/view/status/custom_widget/discharge_pressure.dart';
import 'package:alert_master1/view/status/custom_widget/oil_pressure.dart';
import 'package:alert_master1/view/status/custom_widget/supply_line.dart';
import 'package:alert_master1/view/status/custom_widget/supply_linepressure.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusScreen extends StatelessWidget {
  final MqttController _mqttController = Get.put(MqttController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.cyan,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _mqttController.toggleStatus(),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xffb8f7ff),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(() => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Compressor Status: ",
                                style: TextStyle(fontSize: 18)),
                            Text(
                              _mqttController.comprsw.value == 1 ? "ON" : "OFF",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _mqttController.comprsw.value == 1
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Temperature(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Discharge(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SupplyLine(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SupplyLinepressure(),
                  ),
                ],
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onLongPress: () {
                          Get.defaultDialog(
                            title: "Enter Password",
                            content: Column(
                              children: [
                                TextField(
                                  controller:
                                      _mqttController.passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Enter Password",
                                  ),
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_mqttController
                                            .passwordController.text ==
                                        "123456") {
                                      _mqttController.toggleButton();
                                      Get.back();
                                    } else {
                                      Get.snackbar("Error", "Invalid Password",
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white);
                                    }
                                  },
                                  child: Text("Submit"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: DischargePressure(),
                      ),
                    ),
                    if (_mqttController.toggle.value == true)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onLongPress: () {
                              _mqttController.toggle.value = false;
                            },
                            child: OilPressure()),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
