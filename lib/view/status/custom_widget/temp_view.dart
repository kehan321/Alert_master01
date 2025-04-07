import 'package:alert_master1/controller/mqtt_controller.dart';
import 'package:alert_master1/view/status/custom_widget/Status_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// class TemperatureView extends StatelessWidget {
//   TemperatureView({super.key});

//   final MqttController _mqttController = Get.find<MqttController>();

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         foregroundColor: Colors.white,
//         title: Text("Temperature Readings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.05)),
//         backgroundColor: Colors.black87,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           vertical: screenHeight * 0.01,
//           horizontal: screenWidth * 0.05
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildTemperatureCard(
//               context, "Suction", Icons.thermostat, Colors.redAccent,
//               _mqttController.suctionlinetemp, _mqttController.tempsp2.toDouble().obs, screenWidth
//             ),
//             _buildTemperatureCard(
//               context, "Discharge", Icons.thermostat, Colors.blueAccent,
//               _mqttController.dischargelinetemp, _mqttController.tempsp1.toDouble().obs, screenWidth
//             ),
//             _buildTemperatureCard(
//               context, "Supply", Icons.thermostat, Colors.greenAccent,
//               _mqttController.supplylinetemp, _mqttController.tempsp3.toDouble().obs, screenWidth
//             ),
//             _buildTemperatureCard(
//               context, "return", Icons.thermostat, Colors.greenAccent,
//               _mqttController.supplylinetemp, _mqttController.tempsp3.toDouble().obs, screenWidth
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTemperatureCard(
//     BuildContext context, String label, IconData icon, Color color,
//     RxDouble value, RxDouble spValue, double screenWidth
//   ) {
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => SetPointPage(label: label, spValue: spValue));
//       },
//       child: Card(
//         elevation: 10,
//         margin: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: Container(
//           padding: EdgeInsets.all(screenWidth * 0.05),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             color: Colors.black87,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(icon, color: color, size: screenWidth * 0.12),
//               SizedBox(height: screenWidth * 0.03),
//               Text(label,
//                   style: TextStyle(
//                       fontSize: screenWidth * 0.06,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white)),
//               SizedBox(height: screenWidth * 0.02),
//               Obx(() => Text(
//                     "${value.value}°",
//                     style: TextStyle(
//                         fontSize: screenWidth * 0.07,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   )),
//               SizedBox(height: screenWidth * 0.02),
//               Obx(() => Text(
//                     "SP: ${spValue.value}",
//                     style: TextStyle(
//                         fontSize: screenWidth * 0.05,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white70),
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class TemperatureView extends StatelessWidget {
  TemperatureView({super.key});

  final MqttController _mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          foregroundColor: Colors.white,
          title: Text(
            "Temperature Readings",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: screenWidth * 0.05),
          ),
          backgroundColor: Colors.black87,
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01,
            horizontal: screenWidth * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First Row of Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: _buildTemperatureCard(
                      "Suction",
                      Icons.thermostat,
                      Colors.redAccent,
                      (_mqttController.suctionlinetemp.value <=
                              _mqttController.tempsp2.value)
                          ? Colors.red
                          : Colors.grey,
                      _mqttController.suctionlinetemp,
                      _mqttController.tempsp2.toDouble().obs,
                      screenWidth,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: _buildTemperatureCard(
                      "Discharge",
                      Icons.thermostat,
                      Colors.blueAccent,
                      (_mqttController.dischargelinetemp.value >=
                              _mqttController.tempsp1.value)
                          ? Colors.red
                          : Colors.grey,
                      _mqttController.dischargelinetemp,
                      _mqttController.tempsp1.toDouble().obs,
                      screenWidth,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.015), // Space between rows
              // Second Row of Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: _buildTemperatureCard(
                      "Supply",
                      Icons.thermostat,
                      Colors.greenAccent,
                      (_mqttController.suctionlinetemp.value <=
                              _mqttController.tempsp2.value)
                          ? Colors.grey
                          : Colors.grey,
                      _mqttController.supplylinetemp,
                      _mqttController.tempsp3.toDouble().obs,
                      screenWidth,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: _buildTemperatureCard(
                      "Return",
                      Icons.thermostat,
                      Colors.greenAccent,
                      (_mqttController.returnlinetemp.value <=
                              _mqttController.tempsp4.value)
                          ? Colors.red
                          : Colors.grey,
                      _mqttController.returnlinetemp,
                      _mqttController.tempsp4.toDouble().obs,
                      screenWidth,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildTemperatureCard(
    String label,
    IconData icon,
    Color color,
    Color textColor,
    RxDouble value,
    RxDouble spValue,
    double screenWidth,
  ) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SetPointPage(label: label, spValue: spValue));
      },
      child: Card(
        elevation: 10,
        margin: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
          constraints: BoxConstraints(
            minHeight: screenWidth * 0.4, // Ensuring the card has enough space
            maxHeight: screenWidth * 0.5, // Preventing overflow
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black87,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Icon(icon, color: color, size: screenWidth * 0.08),
              ),
              SizedBox(height: screenWidth * 0.02),
              Flexible(
                child: FittedBox(
                  child: Text(label,
                      style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              SizedBox(height: screenWidth * 0.01),
              Flexible(
                child: Obx(() => FittedBox(
                      child: Text(
                        "${value.value}°",
                        style: TextStyle(
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                    )),
              ),
              SizedBox(height: screenWidth * 0.01),
              Flexible(
                child: Obx(() => FittedBox(
                      child: Text(
                        "SP: ${spValue.value}",
                        style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetPointPage extends StatelessWidget {
  final MqttController _mqttController = Get.find<MqttController>();

  final String label;
  final RxDouble spValue;

  SetPointPage({required this.label, required this.spValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("SetPoint - $label"),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.greenAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Adjust SetPoint for $label",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Obx(
                  () => SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      size: Get.width * 0.5,
                      customWidths: CustomSliderWidths(
                        progressBarWidth: 12,
                        trackWidth: 6,
                      ),
                      customColors: CustomSliderColors(
                        progressBarColors: [
                          Colors.greenAccent,
                          Colors.lightGreen
                        ],
                        trackColor: Colors.white.withOpacity(0.2),
                        dotColor: Colors.greenAccent,
                      ),
                    ),
                    min: -20,
                    max: 200,
                    // initialValue: spValue.value,
                    initialValue: spValue.value.clamp(-20, 200),

                    onChange: (double value) {
                      spValue.value = value;
                    },
                    innerWidget: (double value) => Center(
                      child: Text(
                        "${spValue.value.toStringAsFixed(0)}°C",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  String setPointValue = spValue.value.toStringAsFixed(0);

                  if (label == "Suction") {
                    _mqttController.setTemperature(setPointValue);
                  } else if (label == "Discharge") {
                    _mqttController.dischargeSetPoint(setPointValue);
                  } else if (label == "Supply") {
                    _mqttController.supplyLineSetPoint(setPointValue);
                  } else if (label == "Return") {
                    _mqttController.returnLineSetPoint(setPointValue);
                  }

                  Get.to(() => StatusScreen());
                },
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
