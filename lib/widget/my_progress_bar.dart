import 'dart:async';

import 'package:discount_deals/theme/theme.dart';
import 'package:flutter/material.dart';


class MyProgressBar extends StatefulWidget {
  @override
  _MyProgressBarState createState() => _MyProgressBarState();
}

class _MyProgressBarState extends State<MyProgressBar> {
  double _progressValue = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const duration = const Duration(milliseconds: 10);
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        if (_progressValue >= 1.0) {
          _progressValue = 0.0; // Reset the progress when it reaches 100%
        } else {
          _progressValue += 0.01; // Increment the progress value
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          value: _progressValue,
          strokeWidth: 4.0,
          //backgroundColor: Colors.grey,
          //strokeCap: StrokeCap.round,
          valueColor: AlwaysStoppedAnimation<Color>(MyColors.whiteBG), // Set the progress color
        ),
        // SizedBox(height: 20),
        // Text('Progress: ${(100 * _progressValue).toStringAsFixed(2)}%'),
      ],
    );
  }
}
