import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertController extends GetxController {
  RxList<String> alerts = <String>[].obs;

  void addAlert(String alertMessage) {
    final timestamp = DateTime.now().toLocal().toString().split('.')[0];
    alerts.insert(0, "[$timestamp] $alertMessage");
  }
}

class AlertPage extends StatelessWidget {
  final AlertController alertController = Get.put(AlertController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alerts"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: alertController.alerts.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.redAccent.withOpacity(0.8),
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: Icon(Icons.warning_amber_rounded,
                          color: Colors.white),
                      title: Text(
                        alertController.alerts[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                // Simulate a new alert
                alertController.addAlert("Temperature Exceeded Limit!");
              },
              child: Text("Simulate Alert"),
            ),
          )
        ],
      ),
    );
  }
}
