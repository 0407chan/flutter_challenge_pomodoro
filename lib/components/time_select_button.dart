import 'package:flutter/material.dart';
import 'package:pomodoro/constants/color.dart';

class TimeSelectButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final bool isSelected;
  const TimeSelectButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(
            color: AppColors.whiteSecondary,
            width: 2,
          ),
        ),
        backgroundColor: isSelected ? AppColors.white : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(60, 50),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}
