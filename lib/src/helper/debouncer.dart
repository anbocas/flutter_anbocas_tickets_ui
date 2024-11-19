import 'dart:async';

class Debounced<T> {
  Debounced({required this.milliseconds});
  final int milliseconds;
  Timer? _timer;
  T? _lastValue;

  void run(T value, Function(T) action) {
    _lastValue = value;
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), () {
      if (_lastValue != null) {
        action(_lastValue as T);
      }
    });
  }
}
