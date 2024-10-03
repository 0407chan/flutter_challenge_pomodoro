import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro/components/time_select_button.dart';

const int MINUTES = 1;

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int round = 0, goal = 0;
  bool isRunning = false;
  List<int> timerSelector = [
    15 * MINUTES,
    20 * MINUTES,
    25 * MINUTES,
    30 * MINUTES,
    35 * MINUTES,
  ];
  int currentTimerIndex = 2;
  int timer = 3 * MINUTES;
  late Timer? timerCounter;

  void startTimer() {
    timerCounter = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (timer > 0) {
          timer--;
        } else {
          print('timer ended: $timer');
          t.cancel();
          setState(() {
            isRunning = false;
            round++;
            if (round == 4) {
              goal++;
              round = 0;
            }
            timer = timerSelector[currentTimerIndex];
          });
        }
      });
    });

    setState(() {
      isRunning = true;
    });
  }

  void stopTimer() {
    timerCounter?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timerCounter?.cancel();
    setState(() {
      isRunning = false;
      timer = timerSelector[currentTimerIndex];
    });
  }

  String getHours(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration
        .toString()
        .split('.')
        .first
        .substring(2, 7)
        .split(':')
        .first;
  }

  String getMinutes(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.substring(2, 7).split(':').last;
  }

  void selectTimer(int index) {
    setState(() {
      currentTimerIndex = index;
      timer = timerSelector[currentTimerIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POMOTIMER'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // timer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(getHours(timer)),
              const Text(':'),
              Text(getMinutes(timer)),
            ],
          ),

          // timer selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < timerSelector.length; i++)
                TimeSelectButton(
                  onPressed: () {
                    selectTimer(i);
                  },
                  text: timerSelector[i].toString(),
                  isSelected: currentTimerIndex == i,
                ),
            ],
          ),

          // timer buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isRunning)
                IconButton(
                  onPressed: startTimer,
                  icon: const Icon(Icons.play_arrow),
                ),
              if (isRunning)
                IconButton(onPressed: stopTimer, icon: const Icon(Icons.pause)),
              if (!isRunning)
                IconButton(
                  onPressed: resetTimer,
                  icon: const Icon(Icons.refresh),
                ),
            ],
          ),
          // timer status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('$round/4'),
                  const Text("ROUND"),
                ],
              ),
              Column(
                children: [
                  Text('$goal/12'),
                  const Text("GOAL"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
