import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrFullview extends StatelessWidget {
  const QrFullview({required this.ticketCode, super.key});

  final String ticketCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.iconColor),
        backgroundColor: theme.backgroundColor,
        title: Text(
          "View QR Code",
          style: theme.headingStyle,
        ),
      ),
      backgroundColor: theme.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16.adaptSize),
            child: QrImageView(
              data: ticketCode,
              version: QrVersions.auto,
              dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: theme.qrcodeColor),
              eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square, color: theme.qrcodeColor),
            ),
          ),
          Text(
            ticketCode,
            style: theme.headingStyle,
          ),
        ],
      ),
    );
  }
}
