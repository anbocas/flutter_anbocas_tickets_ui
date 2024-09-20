import 'package:anbocas_tickets_ui/src/anbocas_flutter_ticket_booking.dart';
import 'package:anbocas_tickets_ui/src/screens/manage_attendies/scan_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScanErrorScreen extends StatelessWidget {
  const QrCodeScanErrorScreen({
    super.key,
    required this.barcode,
    required this.status,
    required this.eventId,
  });

  final String barcode;
  final String status;
  final String eventId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.red,
        body: Container(
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
                'Code',
                textAlign: TextAlign.center,
                style: theme.headingStyle?.copyWith(color: Colors.black),
              ),
              Text(
                barcode,
                textAlign: TextAlign.center,
                style: theme.subHeadingStyle?.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 25,
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
              ElevatedButton(
                  child: Text(
                    'Try again.',
                    style: theme.labelStyle?.copyWith(color: Colors.black),
                  ),
                  onPressed: () {
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
                  }),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
