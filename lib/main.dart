import 'package:flutter/material.dart';
import 'package:pomodoro/constants/color.dart';
import 'package:pomodoro/screens/pomodoro_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POMOTIMER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        fontFamily: "pretendard",
        scaffoldBackgroundColor: AppColors.primary,
      ),
      home: const PomodoroScreen(),
    );
  }
}
