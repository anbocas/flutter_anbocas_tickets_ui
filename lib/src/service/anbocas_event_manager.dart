import 'package:eventify/eventify.dart';

class AnbocasEventManager {
  static final AnbocasEventManager _instance = AnbocasEventManager._internal();
  final EventEmitter _eventEmitter = EventEmitter();

  factory AnbocasEventManager() {
    return _instance;
  }

  AnbocasEventManager._internal();

  static const String eventBookingSuccess = 'booking.success';

  void on(String event, Function handler) {
    cb(event, cont) {
      handler(event.eventData);
    }

    _eventEmitter.on(event, null, cb);
  }

  /// Clears all event listeners
  void clear() {
    _eventEmitter.clear();
  }

  void emit(String event, dynamic data) {
    _eventEmitter.emit(event, null, data);
  }
}
