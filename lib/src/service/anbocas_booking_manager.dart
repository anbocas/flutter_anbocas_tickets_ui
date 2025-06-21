import 'package:anbocas_tickets_ui/src/service/anbocas_company_overview.dart';

import 'anbocas_booking_repo.dart';

class AnbocasServiceManager {
  static final AnbocasServiceManager _instance =
      AnbocasServiceManager._internal();

  factory AnbocasServiceManager() {
    return _instance;
  }

  AnbocasServiceManager._internal();

  AnbocasBookingRepo? _bookingRepo;
  AnbocasCompanyOverviewRepo? _overViewRepo;

  void initializeBookingRepo(String baseUrl, String apiKey) {
    _bookingRepo = AnbocasBookingRepo(baseUrl: baseUrl, apiHeaders: {
      "Authorization": "Bearer $apiKey",
    });
  }

  void initializeOverViewRepo(String baseUrl, String apiKey) {
    _overViewRepo = AnbocasCompanyOverviewRepo(baseUrl: baseUrl, apiHeaders: {
      "Authorization": "Bearer $apiKey",
    });
  }

  AnbocasBookingRepo? get bookingRepo => _bookingRepo;
  AnbocasCompanyOverviewRepo? get overviewRepo => _overViewRepo;
}
