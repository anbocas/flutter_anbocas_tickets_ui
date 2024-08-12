import 'package:flutter/material.dart';

mixin SnackbarMixin {
  void showSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
    Color backgroundColor = Colors.blue,
    Color foregroundColor = Colors.white,
  }) {
    context.showSnackBar(message, backgroundColor, foregroundColor,
        duration: duration);
  }

  void showAlertSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
    Color backgroundColor = Colors.red,
    Color foregroundColor = Colors.white,
  }) {
    context.showSnackBar(message, backgroundColor, foregroundColor,
        duration: duration);
  }
}

extension ContextExt on BuildContext {
  void showSnackBar(
      String message, Color backgroundColor, Color foregroundColor,
      {Duration? duration}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: foregroundColor,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      showCloseIcon: true,
    );
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
}
