import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro/components/time_select_button.dart';
import 'package:pomodoro/components/timer_button.dart';
import 'package:pomodoro/constants/color.dart';

const int MINUTES = 1;

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int round = 0, goal = 0, currentTimerIndex = 2, timer = 25 * MINUTES;
  bool isRunning = false, isBreak = false;
  List<int> timerSelector = [
    15 * MINUTES,
    20 * MINUTES,
    25 * MINUTES,
    30 * MINUTES,
    35 * MINUTES,
  ];
  final int breakTime = 5 * MINUTES;
  late Timer? timerCounter;

  @override
  void initState() {
    super.initState();
    timer = timerSelector[currentTimerIndex];
  }

  void startTimer() {
    timerCounter = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timer > 0) {
        timer--;
      } else {
        t.cancel();

        if (isBreak) {
          // 휴식 종료
          isBreak = false;
          isRunning = false;
          timer = timerSelector[currentTimerIndex];
        } else {
          // 뽀모 종료
          isBreak = true;
          round++;
          if (round == 4) {
            goal++;
            round = 0;
          }
          isRunning = false;
          timer = breakTime;
        }
      }

      setState(() {});
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

  void skipBreak() {
    timerCounter?.cancel();
    setState(() {
      isBreak = false;
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
        title: const Text(
          'POMOTIMER',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              SizedBox(height: constraints.maxHeight * 0.1),
              // 타이머
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    decoration: BoxDecoration(
                      color: isBreak ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isBreak
                            ? AppColors.whiteSecondary
                            : AppColors.white,
                        width: 2,
                      ),
                    ),
                    height: 160,
                    alignment: Alignment.center,
                    child: Text(
                      getHours(timer),
                      style: TextStyle(
                        color: isBreak ? AppColors.white : AppColors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -4,
                        fontSize: 80,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    ':',
                    style: TextStyle(
                      color: AppColors.whiteSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 140,
                    height: 160,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isBreak ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isBreak
                            ? AppColors.whiteSecondary
                            : AppColors.white,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 24,
                    ),
                    child: Text(
                      getMinutes(timer),
                      style: TextStyle(
                        color: isBreak ? AppColors.white : AppColors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -4,
                        fontSize: 80,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: constraints.maxHeight * 0.1),
              // 타이머 선택기
              if (isBreak)
                const Center(
                  child: TimeSelectButton(
                    text: 'BREAK',
                    isSelected: false,
                  ),
                ),
              if (!isBreak)
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

              SizedBox(height: constraints.maxHeight * 0.15),
              // 타이머 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TimerButton(
                    onPressed: isRunning ? stopTimer : startTimer,
                    icon: isRunning ? Icons.pause : Icons.play_arrow,
                  ),
                  if (!isRunning && !isBreak) const SizedBox(width: 16),
                  if (!isRunning && !isBreak)
                    TimerButton(
                      onPressed: resetTimer,
                      icon: Icons.refresh,
                    ),
                  if (isBreak) const SizedBox(width: 16),
                  if (isBreak)
                    TimerButton(
                      onPressed: skipBreak,
                      icon: Icons.skip_next,
                    ),
                ],
              ),
              SizedBox(height: constraints.maxHeight * 0.1),
              // 타이머 상태
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        '$round/4',
                        style: const TextStyle(
                          color: AppColors.whiteSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      const Text(
                        "ROUND",
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '$goal/12',
                        style: const TextStyle(
                          color: AppColors.whiteSecondary,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "GOAL",
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
            ],
          );
        },
      ),
    );
  }
}
