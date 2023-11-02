import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  int workTime = 25;
  int breakTime = 5;
  int seconds = 1500;
  double percent = 0;
  bool isWorking = true;
  bool isPaused = true;
  int session = 0;
  // Create a timer object
  late Timer timer;

  // Define a function to start or pause the timer
   void startPauseTimer() {
    setState(() {
      if (isPaused) {
        // If the timer is paused, resume it
        isPaused = false;
        // Create a periodic timer that ticks every second
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            // Update the seconds and percent values
            if (seconds > 0) {
              seconds--;
              percent = seconds / (isWorking ? workTime : breakTime) / 60;
            } else {
              // If the seconds reach zero, switch between work and break modes
              isWorking = !isWorking;
              seconds = (isWorking ? workTime : breakTime) * 60;
              percent = 1.0;
              // Update the session value if the mode is work
              if (isWorking) {
                session++;
                // Reset the session value if it reaches four
                if (session > 3) {
                  session = 0;
                }
              }
            }
          });
        });
      } else {
        // If the timer is running, pause it
        isPaused = true;
        // Cancel the timer
        timer.cancel();
      }
    });
  }

  // Define a function to reset the timer
  void resetTimer() {
    setState(() {
      // Reset the seconds, percent and session values to the initial ones
      seconds = workTime * 60;
      percent = 1.0;
      session = 0;
      // Set the mode to work and pause the timer
      isWorking = true;
      isPaused = true;
      // Cancel the timer if it exists
      timer.cancel();
    });
  }

  // Define a function to update the work time based on the slider value
  void updateWorkTime(double value) {
    setState(() {
      // Round the value to the nearest integer and assign it to workTime
      workTime = value.round();
      // If the mode is work, reset the seconds and percent values accordingly
      if (isWorking) {
        seconds = workTime * 60;
        percent = 1.0;
      }
    });
  }

  // Define a function to update the break time based on the slider value
  void updateBreakTime(double value) {
    setState(() {
      // Round the value to the nearest integer and assign it to breakTime
      breakTime = value.round();
      // If the mode is break, reset the seconds and percent values accordingly
      if (!isWorking) {
        seconds = breakTime * 60;
        percent = 1.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Pomodoro Timer'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 56,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.orangeAccent),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Choose a Task',
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(
                        Icons.edit,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              CircularPercentIndicator(
                radius: 140,
                percent: percent,
                animation: true,
                animateFromLastPercent: true,
                lineWidth: 5,
                curve: Curves.decelerate,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.orange,
                backgroundColor: Colors.white24,
                backgroundWidth: 2,
                center: Text(
                  "${seconds ~/ 60}:${seconds % 60}",
                  style: const TextStyle(fontSize: 50),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: 157,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const DonutSliderThumbCircle(
                      thumbRadius: 10,
                      min: 0,
                      max: 4,
                    ),

                    //Custom added parameters
                    trackHeight: 1,
                    rangeThumbShape: const RoundRangeSliderThumbShape(
                      disabledThumbRadius: 8,
                      enabledThumbRadius: 8,
                    ),

                    tickMarkShape: const RoundSliderTickMarkShape(
                      tickMarkRadius: 6,
                    ),
                    overlayColor: Colors.transparent,
                    inactiveTickMarkColor: Colors.grey,
                    inactiveTrackColor: Colors.grey,
                    thumbColor: Colors.orange,
                    activeTrackColor: Colors.grey,
                    activeTickMarkColor: Colors.orange,
                  ),
                  child: Slider(
                    min: 0,
                    max: 4,
                    value: session.toDouble(),
                    onChanged: (value) {},
                    divisions: 3,
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: startPauseTimer,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.orange,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(color: Colors.orange, blurRadius: 5)
                          ]),
                      child: Icon(
                        isPaused ? Icons.play_arrow : Icons.pause,
                        size: 40,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: resetTimer,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.orange,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(color: Colors.orange, blurRadius: 5)
                          ]),
                      child: const Icon(
                        Icons.refresh,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DonutSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;

  const DonutSliderThumbCircle({
    required this.thumbRadius,
    required this.min,
    required this.max,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final paint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final paintInside = Paint()
      ..color = const Color(0xff1F1B2E)
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    // Draw the outer circle of the thumb
    canvas.drawCircle(center, thumbRadius, paint);
    //Draw inner circle of the thumb
    canvas.drawCircle(center, 8, paintInside);

    // final double startAngle = valueToRadians(min, max, value);

    // Draw the donut-shaped thumb
    paint
      ..color = sliderTheme.activeTickMarkColor!
      ..style = PaintingStyle.fill;

    // canvas.drawArc(
    //   Rect.fromCircle(center: center, radius: thumbRadius),
    //   startAngle,
    //   degToRadians(270),
    //   true,
    //   paint,
    // );
  }
}

double valueToRadians(int min, int max, double value) {
  return ((value - min) / (max - min) * 3 * 3.14 / 2 + 3.14 / 4);
}

double degToRadians(double deg) {
  return deg * 3.14 / 180;
}
