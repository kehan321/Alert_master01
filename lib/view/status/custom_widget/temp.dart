import 'package:alert_master1/view/status/custom_widget/pressure_view.dart';
import 'package:alert_master1/view/status/custom_widget/temp_view.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alert_master1/controller/mqtt_controller.dart';
import 'dart:developer';

class Temperature extends StatefulWidget {
  Temperature({super.key});

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  final MqttController _mqttController = Get.find<MqttController>();

  @override
  void initState() {
    super.initState();
    // Call the checkAndStoreValues after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mqttController.checkAndStoreValues();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: screenWidth * 0.92,
        height: screenHeight * 0.30,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black87,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 45),
            _buildTemperatureRow(),
          ],
        ),
      ),
    );
  }

  /// Builds the header with title and settings button
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            "Temperature",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        IconButton(
          onPressed: () => Get.to(TemperatureView()),
          icon: const Icon(Icons.settings, size: 26, color: Colors.white),
        ),
      ],
    );
  }

  /// Builds the temperature row with columns
  Widget _buildTemperatureRow() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {},
              child: _buildTemperatureColumn(
                  icon: Icons.thermostat,
                  textcolor: (_mqttController.suctionlinetemp.value <=
                          _mqttController.tempsp2.value)
                      ? Colors.red
                      : Colors.grey,
                  color: Colors.red,
                  label: "Suction",
                  value: _mqttController.suctionlinetemp,
                  spValue: _mqttController.tempsp2),
            ),
            _buildTemperatureColumn(
                icon: Icons.thermostat,
                textcolor: (_mqttController.dischargelinetemp.value >=
                        _mqttController.tempsp1.value)
                    ? Colors.red
                    : Colors.grey,
                color: Colors.blue,
                label: "Discharge",
                value: _mqttController.dischargelinetemp,
                spValue: _mqttController.tempsp1),
            _buildTemperatureColumn(
                icon: Icons.thermostat,
                color: Colors.green,
                textcolor: (_mqttController.supplylinetemp.value <=
                        _mqttController.tempsp3.value)
                    ? Colors.grey
                    : Colors.grey,
                label: "Supply",
                value: _mqttController.supplylinetemp,
                spValue: _mqttController.tempsp3),
            _buildTemperatureColumn(
                icon: Icons.thermostat,
                textcolor: (_mqttController.returnlinetemp.value <=
                        _mqttController.tempsp4.value)
                    ? Colors.red
                    : Colors.grey,
                color: Colors.yellow,
                label: "Return",
                value: _mqttController.returnlinetemp,
                spValue: _mqttController.tempsp4),
          ],
        ));
  }

  /// Builds individual temperature columns
  Widget _buildTemperatureColumn({
    required IconData icon,
    required Color color,
    required Color textcolor,
    required String label,
    required RxDouble value,
    required spValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 30),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
        Obx(() => Text(
              "${value.value}°",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: textcolor),
            )),
        Obx(() => Text(
              "SP: ${spValue.value}",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            )),
      ],
    );
  }
}

class Pressure extends StatefulWidget {
  Pressure({super.key});

  @override
  State<Pressure> createState() => _PressureState();
}

class _PressureState extends State<Pressure> {
  final MqttController _mqttController = Get.find<MqttController>();

  final TextEditingController passwordController =
      TextEditingController(); // Declare outside

  void _showPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            const Icon(Icons.lock, color: Colors.blue),
            const SizedBox(width: 10),
            const Text("Enter Password"),
          ],
        ),
        content: TextField(
          controller: passwordController, // Reuse controller
          decoration: InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (passwordController.text == "123456") {
                Get.back(); // Close password dialog
                _showConfirmationDialog(); // ✅ Call separate function for confirmation
              } else {
                Future.delayed(Duration.zero, () {
                  ScaffoldMessenger.of(Get.context!).showSnackBar(
                    const SnackBar(content: Text("Incorrect Password")),
                  );
                });
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  /// ✅ Move Confirmation Dialog to a Separate Function
  void _showConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Action'),
        content: const Text('Are you sure you want to proceed?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Close dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close confirmation dialog
              _mqttController.showOilPressure.value = !_mqttController
                  .showOilPressure.value; // ✅ Proper state update
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onLongPress: () =>
          _showPasswordDialog(context), // Allows repeated unlocking
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: screenWidth * 0.92,
          height: screenHeight * 0.30,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black87,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Settings Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Pressure",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.settings,
                      size: 25,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.to(PressureView());

                      // final pressure1Controller = TextEditingController(
                      //     text: _mqttController.pressuresp2.value.toString());
                      // final pressure2Controller = TextEditingController(
                      //     text: _mqttController.pressuresp1.value.toString());
                      // final pressure3Controller = TextEditingController(
                      //     text: _mqttController.pressuresp3.value.toString());

                      // showDialog(
                      //   context: context,
                      //   builder: (context) => AlertDialog(
                      //     title: const Text("Set Pressure Values"),
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(15)),
                      //     content: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         _buildTextField(
                      //             pressure1Controller, "Supply Pressure"),
                      //         const SizedBox(height: 10),
                      //         _buildTextField(
                      //             pressure2Controller, "Discharge Pressure"),
                      //         const SizedBox(height: 10),
                      //         Obx(() => showOilPressure.value
                      //             ? _buildTextField(
                      //                 pressure3Controller, "Oil Pressure")
                      //             : const SizedBox()),
                      //       ],
                      //     ),
                      //     actions: [
                      //       TextButton(
                      //         onPressed: () {
                      //           _mqttController.supplyLinePressure(
                      //               pressure1Controller.text);
                      //           _mqttController.dischargePressureSetPoint(
                      //               pressure2Controller.text);
                      //           _mqttController.oilPressureSetPoint(
                      //               pressure3Controller.text);
                      //           Navigator.pop(context);
                      //         },
                      //         child: const Text("Save",
                      //             style: TextStyle(fontSize: 16)),
                      //       ),
                      //     ],
                      //   ),
                      // );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 45),
              _buildPressureRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildPressureRow() {
    return Obx(() {
      List<Widget> pressureWidgets = [];

      if (!_mqttController.showOilPressure.value) {
        pressureWidgets.addAll([
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: _buildPressureColumn(
              icon: Icons.speed,
              color: Colors.red,
              label: "Suction",
              value: _mqttController.suctionpressure,
              spValue: _mqttController.pressuresp2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: _buildPressureColumn(
              icon: Icons.speed,
              color: Colors.blue,
              label: "Discharge",
              value: _mqttController.dischargepressure,
              spValue: _mqttController.pressuresp1,
            ),
          ),
        ]);
      } else {
        pressureWidgets.addAll([
          _buildPressureColumn(
            icon: Icons.speed,
            color: Colors.red,
            label: "Suction",
            value: _mqttController.suctionpressure,
            spValue: _mqttController.pressuresp2,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _buildPressureColumn(
              icon: Icons.speed,
              color: Colors.blue,
              label: "Discharge",
              value: _mqttController.dischargepressure,
              spValue: _mqttController.pressuresp1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: _buildPressureColumn(
                icon: Icons.speed,
                color: Colors.green,
                label: "Oil",
                value: _mqttController.oilpressure,
                spValue: _mqttController.pressuresp3,
              ),
            ),
          ),
        ]);
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: pressureWidgets,
      );
    });
  }

  Widget _buildPressureColumn({
    required IconData icon,
    required Color color,
    required String label,
    required RxDouble value,
    required spValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 30),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
        Obx(() => Text(
              "${value.value}°",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            )),
        Obx(() => Text(
              "SP: ${spValue.value}",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            )),
      ],
    );
  }
}
