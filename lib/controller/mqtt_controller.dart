import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttController extends GetxController {
  MqttServerClient? client;
  String topicSSIDvalue = "";
  var tempsp1 = 0.obs;
  var tempsp2 = 0.obs;
  var tempsp3 = 0.obs;

  var pressuresp1 = 0.obs;
  var pressuresp2 = 0.obs;
  var pressuresp3 = 0.obs;

  var dischargelinetemp = 0.obs;
  var suctionlinetemp = 0.obs;
  var supplylinetemp = 0.obs;

  var dischargepressure = 0.obs;
  var suctionpressure = 0.obs;
  var oilpressure = 0.obs;

  var dxstate = 0.obs;
  var mqttBroker = "192.168.18.112".obs;
  var clientId = "flutter45".obs;
  var port = 1883.obs;
  var receivedMessage = "".obs;

  var isConnected = false.obs;
  var message = "".obs;
  var toggle = false.obs;
  var isOn = false.obs;

  @override
  void onInit() {
    log("MQTT controller onit");
    super.onInit();
    _setupMqttClient();
    _connectMqtt();
  }

  void toggleButton() {
    toggle.value = !toggle.value;
  }

  void toggleStatus() {
    isOn.value = !isOn.value;
  }

  updatetopicSSIDvalue(value) {
    print("log 3232:${value} ");
    topicSSIDvalue = value;
    update();
  }

  void _setupMqttClient() {
    client = MqttServerClient(mqttBroker.value, clientId.value);
    client?.port = port.value;
    client?.logging(on: true);
    client?.onDisconnected = _onDisconnected;
    client?.onConnected = _onConnected;
    client?.onSubscribed = _onSubscribed;
  }

  void _onDisconnected() {
    log('Disconnected from MQTT broker.');
    isConnected.value = false;
  }

  void _onConnected() {
    log('Connected to Onconnect.');
    isConnected.value = true;

    client?.subscribe('/KRC/HVAC-AAA001', MqttQos.atLeastOnce);
    client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>>? messages) {
      final MqttPublishMessage msg = messages![0].payload as MqttPublishMessage;

      log('subscribe.');
      log('subscribe_____/KRC/$topicSSIDvalue');
      final String topic = messages[0].topic;
      final String message =
          MqttPublishPayload.bytesToStringAsString(msg.payload.message);
      log(topic);
      log("message1");
      receivedMessage.value = message;

      if (topic == "/KRC/HVAC-AAA001") {
        print('Message Received on /KRC/$topicSSIDvalue: $message');
        _handleMessage(message);
      }
    });
  }

  Future<void> _connectMqtt() async {
    while (true) {
      try {
        log('Attempting to connect...');
        await client?.connect();
        if (client?.connectionStatus?.state == MqttConnectionState.connected) {
          log('Connected to MQTT broker.');
          isConnected.value = true;
          break;
        } else {
          log('Connection failed: ${client?.connectionStatus?.state}');
        }
      } catch (e) {
        log('Exception while connecting: $e');
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void _handleMessage(String message) async {
    try {
      Map<String, dynamic> data = jsonDecode(message);

      tempsp1.value = int.tryParse(data["tempsp1"].toString()) ?? 0;
      tempsp2.value = int.tryParse(data["tempsp2"].toString()) ?? 0;
      tempsp3.value = int.tryParse(data["tempsp3"].toString()) ?? 0;

      pressuresp1.value = int.tryParse(data["pressuresp1"].toString()) ?? 0;
      pressuresp2.value = int.tryParse(data["pressuresp2"].toString()) ?? 0;
      pressuresp3.value = int.tryParse(data["pressuresp3"].toString()) ?? 0;

      dischargelinetemp.value =
          int.tryParse(data["dischargelinetemp"].toString()) ?? 0;
      suctionlinetemp.value =
          int.tryParse(data["suctionlinetemp"].toString()) ?? 0;
      supplylinetemp.value =
          int.tryParse(data["supplylinetemp"].toString()) ?? 0;

      dischargepressure.value =
          int.tryParse(data["dischargepressure"].toString()) ?? 0;
      suctionpressure.value =
          int.tryParse(data["sucrionpressure"].toString()) ?? 0; // Fixed typo
      oilpressure.value = int.tryParse(data["oilpressure"].toString()) ?? 0;

      dxstate.value = int.tryParse(data["dxstate"].toString()) ?? 0;

      log("Received MQTT Data:");
      log("tempsp1 = ${tempsp1.value}");
      log("tempsp2 = ${tempsp2.value}");
      log("tempsp3 = ${tempsp3.value}");
      log("pressuresp1 = ${pressuresp1.value}");
      log("pressuresp2 = ${pressuresp2.value}");
      log("pressuresp3 = ${pressuresp3.value}");
      log("dischargelinetemp = ${dischargelinetemp.value}");
      log("suctionlinetemp = ${suctionlinetemp.value}");
      log("supplylinetemp = ${supplylinetemp.value}");
      log("dischargepressure = ${dischargepressure.value}");
      log("suctionpressure = ${suctionpressure.value}"); // Fixed typo
      log("oilpressure = ${oilpressure.value}");
      log("dxstate = ${dxstate.value}");
    } catch (e) {
      log("Error parsing JSON: $e");
    }
  }

  void buildJsonPayload() {
    Map<String, dynamic> jsonPayload = {
      "tempsp1": tempsp1.value.toString(),
      "tempsp2": tempsp2.value.toString(),
      "tempsp3": tempsp3.value.toString(),
      "pressuresp1": pressuresp1.value.toString(),
      "pressuresp2": pressuresp2.value.toString(),
      "pressuresp3": pressuresp3.value.toString(),
      "dischargelinetemp": dischargelinetemp.value.toString(),
      "suctionlinetemp": suctionlinetemp.value.toString(),
      "supplylinetemp": supplylinetemp.value.toString(),
      "dischargepressure": dischargepressure.value.toString(),
      "suctionpressure": suctionpressure.value.toString(),
      "oilpressure": oilpressure.value.toString(),
      "dxstate": dxstate.value.toString(),
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
