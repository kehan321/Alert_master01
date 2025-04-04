import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;
  final AudioPlayer _player = AudioPlayer();
  Timer? _alarmTimer;

  void _playAlarmContinuously() {
    _alarmTimer?.cancel();
    _alarmTimer = Timer.periodic(Duration(seconds: 1), (_) {
      _player.play(AssetSource('assets/beep.mp3'));
    });
  }

  void _incrementCounter() {
    setState(() {
      counter++;
      if (counter > 10 && _alarmTimer == null) {
        _playAlarmContinuously();
      }
    });
  }

  void _resetCounter() {
    setState(() {
      counter = 0;
    });
    _alarmTimer?.cancel();
    _alarmTimer = null;
  }

  @override
  void dispose() {
    _alarmTimer?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter Alarm App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Count:', style: TextStyle(fontSize: 24)),
            Text('$counter',
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Increment'),
            ),
            ElevatedButton(
              onPressed: _resetCounter,
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
