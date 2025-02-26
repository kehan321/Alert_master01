import 'package:get/get.dart';

class StatusController extends GetxController {
  var isOn = false.obs;
  var suctionLineTemp = 25.obs; // Example temperature value
  var setPoint = 18.obs;
  var toggle = false.obs;

  void toggleStatus() {
    isOn.value = !isOn.value;
  }

  void toggleButton() {
    toggle.value = !toggle.value;
  }
}
