import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  final WearMode mode;

  const TimerScreen(this.mode, {super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _count;
  late String _strCount;
  late String _status;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00:00";
    _status = "Start";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isAmbientMode = widget.mode == WearMode.ambient;
    Color primaryColor =
        isAmbientMode ? Color.fromARGB(255, 0, 212, 46) : Colors.white;
    Color secondaryColor = isAmbientMode
        ? Color.fromARGB(255, 0, 212, 46)
        : (Colors.grey[700] ?? Colors.grey);
    Color iconColor = isAmbientMode
        ? Color.fromARGB(255, 0, 212, 46)
        : (_status == "Stop" ? Colors.red : (Colors.grey[700] ?? Colors.grey));

    return Scaffold(
      backgroundColor:
          isAmbientMode ? Colors.black : (Colors.grey[900] ?? Colors.black),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Cronómetro',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Icon(
                Icons.timer,
                size: 40.0,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _strCount,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildWidgetButton(secondaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButton(Color buttonColor) {
    if (widget.mode == WearMode.active) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              minimumSize: Size(60, 30),
            ),
            onPressed: () {
              if (_status == "Start") {
                _startTimer();
              } else if (_status == "Stop") {
                _timer.cancel();
                setState(() {
                  _status = "Continue";
                });
              } else if (_status == "Continue") {
                _startTimer();
              }
            },
            child: Text(_status),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              minimumSize: Size(60, 30),
            ),
            onPressed: () {
              if (_timer != true) {
                _timer.cancel();
                setState(() {
                  _count = 0;
                  _strCount = "00:00:00";
                  _status = "Start";
                });
              }
            },
            child: const Text("Reset"),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  void _startTimer() {
    setState(() {
      _status = "Stop";
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int hour = _count ~/ 3600;
        int minute = (_count % 3600) ~/ 60;
        int second = (_count % 3600) % 60;
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";
      });
    });
  }
}
