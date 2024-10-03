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
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        begin: isBreak ? AppColors.white : AppColors.primary,
        end: isBreak ? AppColors.primary : AppColors.white,
      ),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      builder: (context, color, child) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // 뒤쪽 박스들
            for (int i = 2; i > 0; i--)
              Positioned(
                top: -i * 6.0,
                left: i * 6.0,
                right: i * 6.0,
                child: Container(
                  width: 140,
                  height: 160,
                  decoration: BoxDecoration(
                    color: isBreak
                        ? AppColors.whiteSecondary.withOpacity(0.1)
                        : AppColors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.whiteSecondary.withOpacity(0),
                      width: 1,
                    ),
                  ),
                ),
              ),
            // 메인 박스
            Container(
              width: 140,
              height: 160,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isBreak ? AppColors.whiteSecondary : AppColors.white,
                  width: 2,
                ),
              ),
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
      },
    );
  }
}
