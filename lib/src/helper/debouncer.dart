import 'dart:async';
import 'package:flutter/material.dart';

class Debounced {
  Debounced({required this.milliseconds});
  final int milliseconds;
  Timer? _timer;
  VoidCallback? _lastAction;
  void run(VoidCallback action) {
    _lastAction = action;
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), () {
      _lastAction?.call();
      _lastAction = null;
    });
  }
}
