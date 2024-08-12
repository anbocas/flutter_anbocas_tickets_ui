import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:flutter/material.dart';

class TicketCardClipper extends CustomClipper<Path> {
  double radius;
  TicketCardClipper({required this.radius});
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(Rect.fromCircle(
        center: Offset(0.0, size.height / 1.5), radius: radius));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 1.5), radius: radius));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TicketCardFillPainter extends CustomPainter {
  final bool isSelected;
  final double radius;

  TicketCardFillPainter({required this.isSelected, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    if (isSelected) {
      final paint = Paint()
        ..color = theme.backgroundColor ?? Colors.transparent;
      final path = Path();
      path.lineTo(0.0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);

      path.addOval(Rect.fromCircle(
          center: Offset(0.0, size.height / 1.5), radius: radius));
      path.addOval(Rect.fromCircle(
          center: Offset(size.width, size.height / 1.5), radius: radius));

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
