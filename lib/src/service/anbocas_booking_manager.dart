import 'anbocas_booking_repo.dart';

class AnbocasServiceManager {
  static final AnbocasServiceManager _instance =
      AnbocasServiceManager._internal();

  factory AnbocasServiceManager() {
    return _instance;
  }

  AnbocasServiceManager._internal();

  AnbocasBookingRepo? _bookingRepo;

  void initializeBookingRepo(String baseUrl, String apiKey) {
    _bookingRepo = AnbocasBookingRepo(baseUrl: baseUrl, apiHeaders: {
      "Authorization": "Bearer $apiKey",
    });
  }

  AnbocasBookingRepo? get bookingRepo => _bookingRepo;
}
