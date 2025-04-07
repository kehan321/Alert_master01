import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class ValueWithTimestamp {
  String name;
  double value;
  DateTime timestamp;
  bool isRead; // Add this property

  ValueWithTimestamp({
    required this.name,
    required this.value,
    required this.timestamp,
    this.isRead = false, // Default to false when creating a new notification
  });
}

class MqttController extends GetxController {
  MqttServerClient? client;
  String topicSSIDvalue = "";
  final RxBool showOilPressure = false.obs;
  final player = AudioPlayer();
  RxBool isHigh = false.obs;

  var tempsp1 = 0.obs;
  var tempsp2 = 0.obs;
  var tempsp3 = 0.obs;
  var tempsp4 = 0.obs;

  var pressuresp1 = 0.obs;
  var pressuresp2 = 0.obs;
  var pressuresp3 = 0.obs;

  var dischargelinetemp = 0.0.obs;
  var suctionlinetemp = 0.0.obs;
  var supplylinetemp = 0.0.obs;
  var returnlinetemp = 0.0.obs;

  var dischargepressure = 0.0.obs;
  var suctionpressure = 0.0.obs;
  var oilpressure = 0.0.obs;

  var comprsw = 0.obs;
  var mqttBroker = "a31qubhv0f0qec-ats.iot.eu-north-1.amazonaws.com".obs;
  RxString clientId = 'mqttx_1b359b239'.obs;
  RxInt port = 8883.obs;
  var receivedMessage = "".obs;

  var isConnected = false.obs;
  var message = "".obs;
  var toggle = false.obs;
  var isOn = false.obs;
  var ip = "".obs;
  TextEditingController passwordController = TextEditingController();

  // Observable list to store values with timestamps
  RxList<ValueWithTimestamp> valueHistory = <ValueWithTimestamp>[].obs;

  bool _hasDischargeAlerted = false;
  bool _hasReturnAlerted = false;
  bool _hasSuctionAlerted = false;

  void checkAndStoreValues() {
    var timestamp = DateTime.now();

    // Discharge check
    if (dischargelinetemp.value >= tempsp1.value) {
      if (!_hasDischargeAlerted) {
        _hasDischargeAlerted = true;
        valueHistory.add(ValueWithTimestamp(
          value: dischargelinetemp.value,
          timestamp: timestamp,
          name: "Discharge",
        ));
        // TODO: Trigger actual notification
      }
    } else {
      _hasDischargeAlerted = false;
    }

    // Return check
    if (returnlinetemp.value <= tempsp4.value) {
      if (!_hasReturnAlerted) {
        _hasReturnAlerted = true;
        valueHistory.add(ValueWithTimestamp(
          value: returnlinetemp.value,
          timestamp: timestamp,
          name: "Return Line",
        ));
        // TODO: Trigger actual notification
      }
    } else {
      _hasReturnAlerted = false;
    }

    // Suction check
    if (suctionlinetemp.value <= tempsp2.value) {
      if (!_hasSuctionAlerted) {
        _hasSuctionAlerted = true;
        valueHistory.add(ValueWithTimestamp(
          value: suctionlinetemp.value,
          timestamp: timestamp,
          name: "Suction",
        ));
        // TODO: Trigger actual notification
      }
    } else {
      _hasSuctionAlerted = false;
    }
  }

  void deleteAlert(String name) {
    valueHistory.removeWhere((element) => element.name == name);

    // Reset the corresponding alert flag
    if (name == "Discharge") {
      _hasDischargeAlerted = false;
    } else if (name == "Return Line") {
      _hasReturnAlerted = false;
    } else if (name == "Suction") {
      _hasSuctionAlerted = false;
    }
  }

  void deleteAllAlerts() {
    valueHistory.clear();
    _hasDischargeAlerted = false;
    _hasReturnAlerted = false;
    _hasSuctionAlerted = false;
  }

  @override
  void onInit() {
    log("MQTT controller onInit");
    super.onInit();
    dischargelinetemp.listen((_) => checkAndStoreValues());
    returnlinetemp.listen((_) => checkAndStoreValues());
    suctionlinetemp.listen((_) => checkAndStoreValues());
    _setupMqttClient();
    _connectMqtt();
  }

  void toggleButton() {
    toggle.value = !toggle.value;
  }

  void toggleStatus() {
    isOn.value = !isOn.value;
  }

  void toggleOilPressure() {
    showOilPressure.value = !showOilPressure.value;
    print("Oil Pressure visibility updated: ${showOilPressure.value}");
  }

  updatetopicSSIDvalue(value) {
    print("log 3232:${value} ");
    topicSSIDvalue = value;
    update();
  }

  void _setupMqttClient() {
    client =
        MqttServerClient.withPort(mqttBroker.value, clientId.value, port.value);
    client?.secure = true;
    client?.keepAlivePeriod = 60;
    client?.setProtocolV311();
    client?.logging(on: false);

    client?.onDisconnected = _onDisconnected;
    client?.onConnected = onConnected;
  }

  void _onDisconnected() {
    log("Disconnected from MQTT broker. Reconnecting...");
    isConnected.value = false;
    Future.delayed(Duration(seconds: 5), _connectMqtt);
  }

  Future<void> _connectMqtt() async {
    if (client == null) {
      log("MQTT Client is not initialized!");
      return;
    }

    try {
      log("Loading certificates...");
      final context = SecurityContext.defaultContext;

      final rootCa = await rootBundle.load('asset/root-CA.crt');
      final deviceCert = await rootBundle.load('asset/Temperature.cert.pem');
      final privateKey = await rootBundle.load('asset/Temperature.private.key');

      context.setClientAuthoritiesBytes(rootCa.buffer.asUint8List());
      context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
      context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

      client!.securityContext = context;
      client!.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(clientId.value)
          .startClean();

      log("Connecting to MQTT broker...");
      await client!.connect();

      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        log('Connected to MQTT broker.');
        isConnected.value = true;
      } else {
        log('Connection failed: ${client!.connectionStatus!.state}');
        client!.disconnect();
      }
    } catch (e) {
      log('MQTT client exception: $e');
      client?.disconnect();
    }
  }

  void onConnected() {
    print("✅ Connected to MQTT Broker!");
    isConnected.value = true;
    // client?.subscribe("#", MqttQos.atMostOnce);
    client?.subscribe("#", MqttQos.atMostOnce);
    client?.updates?.listen(_onMessageReceived);
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage>>? messages) {
    if (messages != null && messages.isNotEmpty) {
      final MqttPublishMessage msg = messages[0].payload as MqttPublishMessage;
      final String topic = messages[0].topic;
      final String message =
          MqttPublishPayload.bytesToStringAsString(msg.payload.message);

      log("Message Received on $topic: $message");
      if (topic == "/KRC/HVAC-AAA001") {
        _handleMessage(message);
      }
    }
  }

  void _handleMessage(String message) async {
    try {
      Map<String, dynamic> data = jsonDecode(message);

      tempsp1.value = int.tryParse(data["tempsp1"].toString()) ?? 0;
      tempsp2.value = int.tryParse(data["tempsp2"].toString()) ?? 0;
      tempsp3.value = int.tryParse(data["tempsp3"].toString()) ?? 0;
      tempsp4.value = int.tryParse(data["tempsp4"].toString()) ?? 0;

      pressuresp1.value = int.tryParse(data["pressuresp1"].toString()) ?? 0;
      pressuresp2.value = int.tryParse(data["pressuresp2"].toString()) ?? 0;
      pressuresp3.value = int.tryParse(data["pressuresp3"].toString()) ?? 0;

      dischargelinetemp.value =
          double.tryParse(data["dischargelinetemp"]) ?? 0.0;
      suctionlinetemp.value =
          double.tryParse(data["suctionlinetemp"].toString()) ?? 0.0;
      supplylinetemp.value =
          double.tryParse(data["supplylinetemp"].toString()) ?? 0.0;
      returnlinetemp.value =
          double.tryParse(data["returnlinetemp"].toString()) ?? 0.0;

      dischargepressure.value =
          double.tryParse(data["dischargepressure"].toString()) ?? 0.0;
      suctionpressure.value =
          double.tryParse(data["suctionpressure"].toString()) ??
              0.0; // Fixed typo
      oilpressure.value =
          double.tryParse(data["oilpressure"].toString()) ?? 0.0;

      comprsw.value = int.tryParse(data["comprsw"].toString()) ?? 0;
      ip.value = data["ip_address"].toString();

      if (tempsp1.value >= dischargelinetemp.value) {
        // Play alert sound
        await player.play(AssetSource('assets/beep.mp3'));
        log("🔊 Sound Played: tempsp1 >= dischargelinetemp");
      } else {
        log("✅ Condition not met: tempsp1 < dischargelinetemp");
      }
      log("Received MQTT Data:");
      log("tempsp1 = ${tempsp1.value}");
      log("tempsp2 = ${tempsp2.value}");
      log("tempsp3 = ${tempsp3.value}");
      log("tempsp4 = ${tempsp4.value}");
      log("pressuresp1 = ${pressuresp1.value}");
      log("pressuresp2 = ${pressuresp2.value}");
      log("pressuresp3 = ${pressuresp3.value}");
      log("dischargelinetemp = ${dischargelinetemp.value}");
      log("suctionlinetemp = ${suctionlinetemp.value}");
      log("supplylinetemp = ${supplylinetemp.value}");
      log("returnlinetemp = ${returnlinetemp.value}");
      log("dischargepressure = ${dischargepressure.value}");
      log("suctionpressure = ${suctionpressure.value}");
      log("oilpressure = ${oilpressure.value}");
      log("dxstate = ${comprsw.value}");
      log("IP_ADDRESS = ${ip.value}");
    } catch (e) {
      log("Error parsing JSON: $e");
    }
  }

  void buildJsonPayload() {
    Map<String, dynamic> jsonPayload = {
      "tempsp1": tempsp1.value.toString(),
      "tempsp2": tempsp2.value.toString(),
      "tempsp4": tempsp4.value.toString(),
      "pressuresp1": pressuresp1.value.toString(),
      "pressuresp2": pressuresp2.value.toString(),
      "pressuresp3": pressuresp3.value.toString(),
      "dischargelinetemp": dischargelinetemp.value.toString(),
      "suctionlinetemp": suctionlinetemp.value.toString(),
      "returnlinetemp": returnlinetemp.value.toString(),
      "dischargepressure": dischargepressure.value.toString(),
      "suctionpressure": suctionpressure.value.toString(),
      "oilpressure": oilpressure.value.toString(),
      "comprsw": comprsw.value.toString(),
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

  void publishMessage(String message) {
    String topic = "/test/HVAC-AAA001/1";
    if (client != null) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);

      try {
        client!.publishMessage(
          topic,
          MqttQos.atLeastOnce,
          builder.payload!,
          retain: true,
        );
        log('Message published to $topic: $message');
      } catch (e) {
        log('Failed to publish message: $e');
      }
    }
  }

  void setTemperature(String sp) {
    tempsp2.value = int.tryParse(sp) ?? 0;
    buildJsonPayload();
  }

  void dischargeSetPoint(String sp) {
    tempsp1.value = int.tryParse(sp) ?? 0;
    buildJsonPayload();
  }

  void supplyLineSetPoint(String sp) {
    tempsp3.value = int.tryParse(sp) ?? 0;
    buildJsonPayload();
  }

  void returnLineSetPoint(String sp) {
    tempsp4.value = int.tryParse(sp) ?? 0;
    buildJsonPayload();
  }

  void supplyLinePressure(String sp) {
    pressuresp2.value = int.tryParse(sp) ?? 0;
    buildJsonPayload();
  }

  void dischargePressureSetPoint(String sp) {
    pressuresp1.value = int.tryParse(sp) ?? 0;
    buildJsonPayload();
  }

  void oilPressureSetPoint(String sp) {
    pressuresp3.value = int.tryParse(sp) ?? 0;
    buildJsonPayload();
  }
}
