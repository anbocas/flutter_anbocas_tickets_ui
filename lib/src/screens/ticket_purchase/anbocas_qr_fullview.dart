import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrFullview extends StatefulWidget {
  const QrFullview({required this.ticketCodes, super.key});

  final List<String> ticketCodes;

  @override
  State<QrFullview> createState() => _QrFullviewState();
}

class _QrFullviewState extends State<QrFullview> {
  int currentPage = 1;

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
        children: [
          Expanded(
            child: PageView.builder(
                itemCount: widget.ticketCodes.length,
                onPageChanged: (value) {
                  if (mounted) {
                    setState(() {
                      currentPage = value + 1;
                    });
                  }
                },
                itemBuilder: (context, index) {
                  final ticketCode = widget.ticketCodes[index];
                  return Column(
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
                              eyeShape: QrEyeShape.square,
                              color: theme.qrcodeColor),
                        ),
                      ),
                      Text(
                        ticketCode,
                        style: theme.headingStyle,
                      ),
                    ],
                  );
                }),
          ),
          Divider(
            color: theme.dividerColor,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.v),
            child: Text(
              '$currentPage/${widget.ticketCodes.length}',
              style: theme.labelStyle,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
