import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_api/anbocas_tickets_api.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/screens/ticket_crud/ticket_listing_screen.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_manager.dart';
import 'package:flutter/material.dart';

class AnbocasTickets {
  AnbocasTickets._internal();

  static final AnbocasTickets instance = AnbocasTickets._internal();

  factory AnbocasTickets() => instance;

  void config({
    required String apikey,
    AnbocasCustomTheme? customThemeConfig,
  }) {
    final serviceManager = AnbocasServiceManager();
    serviceManager.initializeBookingRepo("https://sandbox.anbocas.com", apikey);
    theme.updateConfig(customThemeConfig);
    AnbocasRequestPlugin.instance?.config(token: apikey, enableLog: true);
  }

  void launchBookingFlow({
    required String eventId,
    required BuildContext context,
    bool allowGroupTicket = false,
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
              allowGroupTicket: allowGroupTicket,
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
}

final theme = AnbocasCustomTheme();
final userConfig = UserConfig();
