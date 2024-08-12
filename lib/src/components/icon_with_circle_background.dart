import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:flutter/material.dart';

class IconWithCircleBackground extends StatelessWidget {
  final IconData icon;
  final Color color;
  final void Function()? onPressed;

  const IconWithCircleBackground({
    Key? key,
    required this.icon,
    required this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 20.h,
        height: 20.v,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black,
            size: 15.adaptSize,
          ),
        ),
      ),
    );
  }
}
