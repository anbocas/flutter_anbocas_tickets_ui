import 'package:flutter/material.dart';

class DottedLine extends CustomPainter {
  double radius;
  DottedLine({required this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3;
    double dashSpace = 4;
    double startX = radius;

    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    while (startX < size.width - radius) {
      canvas.drawLine(Offset(startX, size.height / 1.5),
          Offset(startX + dashWidth, size.height / 1.5), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
