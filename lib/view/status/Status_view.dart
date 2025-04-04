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

// class _StatusScreenState extends State<StatusScreen> {
//   final MqttController _mqttController = Get.put(MqttController());

//   final AudioPlayer _player = AudioPlayer();

//   Timer? _alarmTimer;

//   void _playAlarmContinuously() {
//     _alarmTimer?.cancel();
//     _alarmTimer = Timer.periodic(Duration(seconds: 1), (_) {
//       _player.play(AssetSource('beep.mp3'));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Alert Master",
//           style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1.2,
//               color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.black87, // Custom color
//         shadowColor: Colors.black87,
//         toolbarHeight: 80, // Slightly taller toolbar for better spacing
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(15),
//           ),
//         ),
//         actions: [
//           Obx(() {
//             return IconButton(
//               icon: Icon(
//                 Icons.settings,
//                 size: 26,
//                 color: _mqttController.isConnected.value
//                     ? Colors.green
//                     : Colors.red,
//               ),
//               onPressed: () {
//                 _playAlarmContinuously();
//               },
//             );
//           }),
//         ],
//       ),
//       backgroundColor: Get.isDarkMode ? Colors.black : Colors.black87,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Obx(() => GestureDetector(
//                     onTap: () => _mqttController.toggleStatus(),
//                     child: Card(
//                       elevation: 5,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15)),
//                       child: Container(
//                         width: screenWidth * 0.92,
//                         height: screenHeight * 0.09,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           color: Colors.black87,
//                         ),
//                         child: Row(
//                           mainAxisSize:
//                               MainAxisSize.min, // Keeps row size minimal
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Compressor ",
//                               style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                             ),
//                             SizedBox(
//                               width: screenWidth * 0.35,
//                             ), // Small spacing
//                             Container(
//                               width: screenWidth * 0.18,
//                               height: screenHeight * 0.05, // Adjusted height
//                               alignment: Alignment
//                                   .center, // Center text inside the box
//                               decoration: BoxDecoration(
//                                 color: _mqttController.comprsw.value == 1
//                                     ? Colors.green
//                                     : Colors.red,
//                                 borderRadius:
//                                     BorderRadius.circular(8), // Rounded corners
//                               ),
//                               child: Text(
//                                 _mqttController.comprsw.value == 1
//                                     ? "ON"
//                                     : "OFF",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors
//                                       .white, // White text for better contrast
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )),
//               SizedBox(height: 10),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Temperature(),
//                   ),
//                   SizedBox(height: 5),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Pressure(),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class _StatusScreenState extends State<StatusScreen> {
  final MqttController _mqttController = Get.put(MqttController());
  final AudioPlayer _player = AudioPlayer();
  Timer? _alarmTimer;

  // Function to play alarm sound continuously
  void _playAlarmContinuously() {
    _alarmTimer?.cancel();
    _alarmTimer = Timer.periodic(Duration(seconds: 1), (_) async {
      try {
        await _player.play(AssetSource('assets/beep.mp3'));
        print("Playing alarm sound...");
      } catch (e) {
        print("Error playing alarm sound: $e");
      }
    });
  }

  // Function to stop alarm sound
  void _stopAlarm() {
    _alarmTimer?.cancel();
    _player.stop();
    print("Alarm stopped.");
  }

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
                Get.to(AlertPage());
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
              onPressed: () {
                _playAlarmContinuously();
                print("Alarm sound triggered from AppBar!");
              },
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
