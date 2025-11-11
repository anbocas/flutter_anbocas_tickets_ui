import 'dart:async';

import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/screens/manage_attendies/scan_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScanSuccessScreen extends StatelessWidget {
  const QrCodeScanSuccessScreen(
      {super.key,
      required this.barcode,
      required this.status,
      required this.eventId,
      required this.ticketName,
      required this.name,
      required this.price});

  final String barcode;
  final String eventId;
  final String status;
  final String ticketName;
  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (ctx, __, ___) => ScanQrScreen(
            checkInOptions: CheckInOptions.ticket,
            eventId: eventId,
          ),
        ),
      );
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                QrImageView(
                  data: barcode,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: theme.headingStyle?.copyWith(color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text("Ticket Name - $ticketName", style: theme.labelStyle),
                const SizedBox(
                  height: 5,
                ),
                Text("Ticket Price - $price", style: theme.labelStyle),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Status',
                  textAlign: TextAlign.center,
                  style: theme.bodyStyle?.copyWith(color: Colors.black),
                ),
                Text(
                  status,
                  textAlign: TextAlign.center,
                  style: theme.bodyStyle?.copyWith(color: Colors.white),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
