import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/session.dart';
import '../models/day.dart';
import '../models/time_interval.dart';
import '../utils/time_utils.dart';

class TimingPage extends StatefulWidget {
  const TimingPage({super.key});

  @override
  State<TimingPage> createState() => _TimingPageState();
}

class _TimingPageState extends State<TimingPage> {
  late Stopwatch stopwatch;
  late Timer timer;
  bool working = false;
  Session currentSession = Session(startTime: Duration.zero);
  List<Day> days = [];

  void handleStartSwitch() {
    if (!stopwatch.isRunning) {
      currentSession = Session(startTime: timeOfDay(DateTime.now()));
      stopwatch.start();
      working = true;
      setState(() {});
    }
    else{
      stopwatch.stop();
      currentSession.addInterval(TimeInterval(
        working ? IntervalType.work : IntervalType.rest,
        truncateToSecond(stopwatch.elapsed)));
      working = !working;
      stopwatch
        ..reset()
        ..start();
      setState(() {});
      }
    }

  void handleFinish() {
    stopwatch.stop();
    if (working){
      currentSession.addInterval(TimeInterval(
        IntervalType.work,
        truncateToSecond(stopwatch.elapsed)
        )
      );
    }
    stopwatch.reset();
    working = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();

    timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      if (!mounted) return;
      if (stopwatch.isRunning) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final runningColor = working ? Colors.deepPurple : Colors.deepOrange;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Stopwatch, work time, rest time
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  // Stopwatch/ START button
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    decoration: BoxDecoration(
                      color: runningColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: runningColor, width: 2),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: handleStartSwitch,
                      child: stopwatch.isRunning ?
                       Text(
                        formatDuration(stopwatch.elapsed),
                        style: TextStyle(
                          color: runningColor,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      )
                      : Text(
                          'START',
                          style: TextStyle(
                          color: runningColor,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),

                  // Totals
                  Text(
                    working ? formatDuration(currentSession.workTime + truncateToSecond(stopwatch.elapsed)) 
                      : formatDuration(currentSession.workTime),
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      height:1.1,
                    ),
                  ),

                  Text(
                    !working ? formatDuration(currentSession.restTime + truncateToSecond(stopwatch.elapsed)) 
                      : formatDuration(currentSession.restTime),
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                    ),
                  ),

                  // FINISH button
                  stopwatch.isRunning ?
                  CupertinoButton.filled(
                    onPressed: handleFinish,
                    borderRadius: BorderRadius.circular(12),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: const Text(
                      'FINISH',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                    ),
                  )
                  : SizedBox(
                    height:49,
                  ),
                ],
              ),
            ),

            // List of intervals under everything
            Expanded(
              child: ListView(
                children: currentSession.intervals
                    .map(
                      (interval) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: Text(
                          formatDuration(interval.length),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                            color: interval.type == IntervalType.work ? Colors.deepPurple
                             : Colors.deepOrange,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
