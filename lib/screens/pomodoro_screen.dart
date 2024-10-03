import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/components/counter_card.dart';
import 'package:pomodoro/components/time_select_button.dart';
import 'package:pomodoro/components/timer_button.dart';
import 'package:pomodoro/constants/color.dart';

const int MINUTES = 60;

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
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    timer = timerSelector[currentTimerIndex];
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
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
          _confettiController.play(); // 꽃가루 효과 시작
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
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  // 타이머
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CounterCard(
                        text: getHours(timer),
                        isBreak: isBreak,
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
                      CounterCard(
                        text: getMinutes(timer),
                        isBreak: isBreak,
                      ),
                    ],
                  ),

                  SizedBox(height: constraints.maxHeight * 0.1),
                  // 타이머 선택기
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    crossFadeState: isBreak
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: const Center(
                      child: TimeSelectButton(
                        text: 'BREAK',
                        isSelected: false,
                      ),
                    ),
                    secondChild: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 0; i < timerSelector.length; i++)
                          TimeSelectButton(
                            onPressed: () {
                              selectTimer(i);
                            },
                            text: (timerSelector[i] / 60).floor().toString(),
                            isSelected: currentTimerIndex == i,
                          ),
                      ],
                    ),
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
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 10,
              minBlastForce: 5,
              emissionFrequency: 0.9, // 빈도를 높여 거의 동시에 방출되도록 함
              numberOfParticles: 50,
              gravity: 0.1,
              particleDrag: 0.05,
              minimumSize: const Size(5, 5),
              maximumSize: const Size(8, 8),
              shouldLoop: false, // 한 번만 실행되도록 설정
            ),
          ),
        ],
      ),
    );
  }
}
