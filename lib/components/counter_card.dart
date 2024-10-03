import 'package:flutter/material.dart';
import 'package:pomodoro/constants/color.dart';

class CounterCard extends StatelessWidget {
  final String text;
  final bool isBreak;

  const CounterCard({
    super.key,
    required this.text,
    required this.isBreak,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 140,
          decoration: BoxDecoration(
            color: isBreak ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isBreak ? AppColors.whiteSecondary : AppColors.white,
              width: 2,
            ),
          ),
          height: 160,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isBreak ? AppColors.white : AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: -4,
              fontSize: 80,
            ),
          ),
        ),
      ],
    );
  }
}
