import 'package:alert_master1/controller/mqtt_controller.dart';
import 'package:alert_master1/view/status/custom_widget/Status_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PressureView extends StatelessWidget {
  PressureView({super.key});

  final MqttController _mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        title: Text("Pressure Readings",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: screenWidth * 0.05)),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.0, horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Even spacing
          children: [
            _buildTemperatureCard(
                context,
                "Suction",
                Icons.thermostat,
                Colors.redAccent,
                _mqttController.suctionpressure,
                _mqttController.pressuresp2.toDouble().obs,
                screenWidth),
            _buildTemperatureCard(
                context,
                "Discharge",
                Icons.thermostat,
                Colors.blueAccent,
                _mqttController.dischargepressure,
                _mqttController.pressuresp1.toDouble().obs,
                screenWidth),
            Obx(() => _mqttController.showOilPressure.value
                ? _buildOilCard(
                    context,
                    "Oil",
                    Icons.thermostat,
                    Colors.greenAccent,
                    _mqttController.oilpressure,
                    _mqttController.pressuresp3.toDouble().obs,
                    screenWidth,
                    _mqttController.isHigh)
                : SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureCard(
      BuildContext context,
      String label,
      IconData icon,
      Color color,
      RxDouble value,
      RxDouble spValue,
      double screenWidth) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SetPointPage(label: label, spValue: spValue));
      },
      child: Card(
        elevation: 10,
        margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black87,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: screenWidth * 0.12),
              SizedBox(height: screenWidth * 0.03),
              Text(label,
                  style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(height: screenWidth * 0.02),
              Obx(() => Text(
                    "${value.value}°",
                    style: TextStyle(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
              SizedBox(height: screenWidth * 0.02),
              Obx(() => Text(
                    "SP: ${spValue.value}",
                    style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOilCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    RxDouble value,
    RxDouble spValue,
    double screenWidth,
    RxBool isHigh,
  ) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SetPointPage(label: label, spValue: spValue));
      },
      child: Card(
        elevation: 10,
        margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: screenWidth * 0.6,
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black87,
          ),
          child: Obx(() => Stack(
                children: [
                  // Conditional rendering inside Obx
                  Center(
                    child: isHigh.value
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(icon,
                                  color: color, size: screenWidth * 0.12),
                              SizedBox(height: screenWidth * 0.03),
                              Text(
                                label,
                                style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(height: screenWidth * 0.02),
                              Text(
                                (_mqttController.comprsw.value == 1)
                                    ? "High"
                                    : "Low",
                                style: TextStyle(
                                    fontSize: screenWidth * 0.07,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(icon,
                                  color: color, size: screenWidth * 0.12),
                              SizedBox(height: screenWidth * 0.03),
                              Text(
                                label,
                                style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(height: screenWidth * 0.02),
                              Text(
                                "${value.value}°",
                                style: TextStyle(
                                    fontSize: screenWidth * 0.07,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(height: screenWidth * 0.02),
                              Text(
                                "SP: ${spValue.value}",
                                style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70),
                              ),
                            ],
                          ),
                  ),

                  // Settings icon at top-right
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.settings,
                          color: Colors.white70, size: screenWidth * 0.08),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            content: Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Sensor",
                                    style: TextStyle(
                                        color: isHigh.value
                                            ? Colors.red
                                            : Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Switch(
                                    value: isHigh.value,
                                    onChanged: (val) {
                                      isHigh.value = val; // Update the value
                                      Future.delayed(
                                          Duration(milliseconds: 200), () {
                                        Navigator.pop(
                                            context); // Close the dialog after 1 second
                                      });
                                    },
                                    activeColor: Colors.red,
                                  ),
                                  Text(
                                    "Switch",
                                    style: TextStyle(
                                        color: isHigh.value
                                            ? Colors.red
                                            : Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )),
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
                    min: 0,
                    max: 100,
                    initialValue: spValue.value,
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
                    _mqttController.supplyLinePressure(setPointValue);
                  } else if (label == "Discharge") {
                    _mqttController.dischargePressureSetPoint(setPointValue);
                  } else if (label == "Oil") {
                    _mqttController.oilPressureSetPoint(setPointValue);
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
