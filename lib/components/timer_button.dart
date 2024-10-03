import 'package:flutter/material.dart';
import 'package:pomodoro/constants/color.dart';

class TimerButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;

  const TimerButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: AppColors.white,
        size: 48,
      ),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.secondary,
        padding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
