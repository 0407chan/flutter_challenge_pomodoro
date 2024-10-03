import 'package:flutter/material.dart';

class TimeSelectButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final bool isSelected;
  const TimeSelectButton({
    super.key,
    required this.onPressed,
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
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.black,
            width: 2,
          ),
        ),
        backgroundColor: isSelected ? Colors.black : Colors.transparent,
        padding: const EdgeInsets.all(0),
        minimumSize: const Size(60, 40),
      ),
      child: Text(text),
    );
  }
}
