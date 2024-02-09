import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color progressColor;

  const ProgressBar({
    super.key,
    required this.value,
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          Container(
            width: width * value,
            height: height,
            decoration: BoxDecoration(
              color: progressColor,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        ],
      ),
    );
  }
}
