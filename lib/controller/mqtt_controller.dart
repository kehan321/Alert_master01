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
  var deviceID = 0.obs;
  var dxtemp = 0.obs;
  var dxtempsp = 0.obs;
  var dxstate = 77.obs;
  var alarmString = 0.obs;
  var timenow = 0.obs;
  var myIP = ''.obs;
  var packetSequence = 0.obs;
  var ssid = ''.obs;
  var password = ''.obs;
  var mqttBroker = "192.168.18.112".obs;
  var clientId = "flutter45".obs;
  var port = 1883.obs;
  var receivedMessage = "".obs;

  var isConnected = false.obs;
  var message = "".obs;

  @override
  void onInit() {
    log("MQTT controller onit");
    super.onInit();
    _setupMqttClient();
    _connectMqtt();
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

    client?.subscribe('/KRC/AM1/1', MqttQos.atLeastOnce);
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

      if (topic == "/KRC/AM1/1") {
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
      Map<String, dynamic> jsonMap = jsonDecode(message);

      deviceID.value =
          int.tryParse(jsonMap['device_id']?.toString() ?? '') ?? 0;
      dxtemp.value = int.tryParse(jsonMap['dxtemp']?.toString() ?? '') ?? 0;
      dxtempsp.value = int.tryParse(jsonMap['dxtempsp']?.toString() ?? '') ?? 0;
      dxstate.value = int.tryParse(jsonMap['dxstate']?.toString() ?? '') ?? 0;
      alarmString.value = int.tryParse(jsonMap['alarm']?.toString() ?? '') ?? 0;
      timenow.value = int.tryParse(jsonMap['timenow']?.toString() ?? '') ?? 0;
      myIP.value = jsonMap['ip_address']?.toString() ?? '';
      packetSequence.value =
          int.tryParse(jsonMap['packet_id']?.toString() ?? '') ?? 0;
      ssid.value = jsonMap['ssid']?.toString() ?? '';
      password.value = jsonMap['password']?.toString() ?? '';

      log("Received MQTT Data:");
      log("device_id = $deviceID");
      log("dxtemp = $dxtemp");
      log("dxtempsp = $dxtempsp");
      log("dxstate = $dxstate");
      log("alarm = $alarmString");
      log("timenow = $timenow");
      log("ip_address = $myIP");
      log("packet_id = $packetSequence");
      log("ssid = $ssid");
      log("password = $password");
    } catch (e) {
      log("Error parsing JSON: $e");
    }
  }

  void buildJsonPayload() {
    Map<String, dynamic> jsonPayload = {
      "dxtempsp": dxtempsp.value.toString(),
      "dxstate": dxstate.value.toString(),
      "alarm": alarmString.value.toString(),
      "timenow": timenow.value.toString(),
      "ip_address": myIP.value.toString(),
      "packet_id": packetSequence.value.toString(),
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

  void publishMessage(String message) {
    String topic = "/test/AM1/";
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

  // void setTemperature(String sp) {
  //   dxstate.value = int.tryParse(sp) ?? 0;
  //   buildJsonPayload();
  // }
}
