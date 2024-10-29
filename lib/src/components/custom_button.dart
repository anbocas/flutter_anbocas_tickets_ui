import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.onPressedCallback,
    this.buttonSize,
    required this.centerText,
  }) : super(key: key);

  final void Function()? onPressedCallback;
  final String centerText;
  final Size? buttonSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressedCallback,
      style: theme.buttonStyle?.copyWith(
          minimumSize: WidgetStatePropertyAll<Size>(
              buttonSize ?? Size(double.infinity, 50.v))),
      child: Text(
        centerText,
        style: theme.labelStyle
      ),
    );
  }
}
