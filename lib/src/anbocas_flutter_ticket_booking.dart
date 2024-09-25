import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_api/anbocas_tickets_api.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/screens/manage_attendies/event_check_in_list_screen.dart';
import 'package:anbocas_tickets_ui/src/screens/ticket_crud/ticket_listing_screen.dart';
import 'package:anbocas_tickets_ui/src/screens/ticket_purchase/anbocas_order_detail_screen.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_manager.dart';
import 'package:flutter/material.dart';

class AnbocasTickets {
  AnbocasTickets._internal();

  static final AnbocasTickets instance = AnbocasTickets._internal();

  factory AnbocasTickets() => instance;

  String baseUrl = 'https://api.anbocas.com';

  void config({
    required String apikey,
    ApiMode apiMode = ApiMode.sandbox,
    AnbocasCustomTheme? customThemeConfig,
  }) {
    final serviceManager = AnbocasServiceManager();

    if (apiMode == ApiMode.sandbox) {
      baseUrl = 'https://sandbox-api.anbocas.com';
    } else {
      baseUrl = 'https://api.anbocas.com';
    }

    serviceManager.initializeBookingRepo(baseUrl, apikey);
    theme.updateConfig(customThemeConfig);
    AnbocasTicketsApi.instance
        ?.config(token: apikey, enableLog: true, mode: apiMode);
  }

  void launchBookingFlow({
    required String eventId,
    String? referenceEventId,
    required BuildContext context,
    UserConfig? userMetaData,
  }) {
    try {
      if (userMetaData != null) {
        userConfig.updateConfig(userMetaData);
      }
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (ctx, __, ___) {
            if (MediaQueryHolder().mediaQueryData == null) {
              MediaQueryHolder().initialize(ctx);
            }
            return AnbocasTicketBookingWidget(
              eventId: eventId,
              referenceEventId: referenceEventId,
            );
          },
        ),
      );
    } catch (e) {
      // log(e.toString());
    }
  }

  void manageTickets({
    required BuildContext context,
    required String eventId,
  }) {
    try {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (ctx, __, ___) {
            if (MediaQueryHolder().mediaQueryData == null) {
              MediaQueryHolder().initialize(ctx);
            }
            return TicketListingScreen(
              eventId: eventId,
            );
          },
        ),
      );
    } catch (e) {
      // log(e.toString());
    }
  }

  void manageAttendees({
    required BuildContext context,
    required String eventId,
  }) {
    try {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (ctx, __, ___) {
            if (MediaQueryHolder().mediaQueryData == null) {
              MediaQueryHolder().initialize(ctx);
            }
            return EventCheckInListScreen(
              eventId: eventId,
            );
          },
        ),
      );
    } catch (e) {
      // log(e.toString());
    }
  }

  void viewOrderSummary({
    required BuildContext context,
    required String anbocasOrderId,
    String? referenceEventId,
  }) {
    try {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (ctx, __, ___) {
            if (MediaQueryHolder().mediaQueryData == null) {
              MediaQueryHolder().initialize(ctx);
            }
            return AnbocasOrderDetailScreen(
                anbocasOrderId: anbocasOrderId,
                referenceEventId: referenceEventId,
                );
          },
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

final theme = AnbocasCustomTheme();
final userConfig = UserConfig();
