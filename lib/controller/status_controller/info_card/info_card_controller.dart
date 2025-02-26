import 'package:get/get.dart';

class InfoController extends GetxController {
  var title = "Temperature".obs;

  var value1 = 25.obs;
  var subText2 = "Set Point".obs;
  var value2 = 18.obs;

  // Function to update values dynamically
  void updateValues(int newValue1, int newValue2) {
    value1.value = newValue1;
    value2.value = newValue2;
  }
}

class InfoController1 extends GetxController {
  var title = "Discharge".obs;
  var subText1 = "current temp".obs;
  var value1 = 25.obs;
  var subText2 = "Set Point".obs;
  var value2 = 18.obs;

  // Function to update values dynamically
  void updateValues(int newValue1, int newValue2) {
    value1.value = newValue1;
    value2.value = newValue2;
  }
}

class InfoController2 extends GetxController {
  var title = "Supply line".obs;
  var subText1 = "current temp".obs;
  var value1 = 25.obs;
  var subText2 = "Set Point".obs;
  var value2 = 18.obs;

  // Function to update values dynamically
  void updateValues(int newValue1, int newValue2) {
    value1.value = newValue1;
    value2.value = newValue2;
  }
}

class InfoController3 extends GetxController {
  var title = "S.L.P".obs;
  var subText1 = "current psi".obs;
  var value1 = 25.obs;
  var subText2 = "Set psi".obs;
  var value2 = 18.obs;

  // Function to update values dynamically
  void updateValues(int newValue1, int newValue2) {
    value1.value = newValue1;
    value2.value = newValue2;
  }
}

class InfoController4 extends GetxController {
  var title = "Discharge".obs;
  var subText1 = "current psi".obs;
  var value1 = 25.obs;
  var subText2 = "Set psi".obs;
  var value2 = 18.obs;

  // Function to update values dynamically
  void updateValues(int newValue1, int newValue2) {
    value1.value = newValue1;
    value2.value = newValue2;
  }
}

class InfoController5 extends GetxController {
  var title = "Oil Pressure".obs;
  var subText1 = "current psi".obs;
  var value1 = 25.obs;
  var subText2 = "Set Point".obs;
  var value2 = 18.obs;

  // Function to update values dynamically
  void updateValues(int newValue1, int newValue2) {
    value1.value = newValue1;
    value2.value = newValue2;
  }
}
