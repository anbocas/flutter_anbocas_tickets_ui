import 'package:eventify/eventify.dart';

class AnbocasEventManager {
  static final AnbocasEventManager instance = AnbocasEventManager._internal();
  final EventEmitter _eventEmitter = EventEmitter();

  AnbocasEventManager._internal();

  static const String eventBookingSuccess = 'booking.success';
  static const String viewEvent = 'view.event';

  void on(String event, Function(dynamic) handler) {
    _eventEmitter.on(event, null, (ev, context) {
      handler(ev.eventData);
    });
  }

  /// Clears all event listeners
  void clear() {
    _eventEmitter.clear();
  }

  void emit(String event, dynamic data) {
    _eventEmitter.emit(event, null, data);
  }
}