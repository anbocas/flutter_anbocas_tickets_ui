import 'package:flutter/material.dart';

class DottedLine extends CustomPainter {
  double radius;
  Color color;
  DottedLine({required this.radius, this.color = Colors.grey});
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3;
    double dashSpace = 4;
    double startX = radius;

    final paint = Paint()
      ..color = color
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
