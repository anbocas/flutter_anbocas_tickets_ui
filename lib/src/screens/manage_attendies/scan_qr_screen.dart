import 'package:anbocas_tickets_api/anbocas_tickets_api.dart';
import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/screens/manage_attendies/qrcode_scan_already_scanned_screen.dart';
import 'package:anbocas_tickets_ui/src/screens/manage_attendies/qrcode_scan_error_screen.dart';
import 'package:anbocas_tickets_ui/src/screens/manage_attendies/qrcode_scan_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

enum CheckInOptions {
  ticket(name: 'Ticket'),
  order(name: 'Order');

  final String name;

  const CheckInOptions({required this.name});
}

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({
    super.key,
    required this.checkInOptions,
    required this.eventId,
  });

  final CheckInOptions checkInOptions;
  final String eventId;

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final _eventApi = AnbocasTicketsApi.event;
  late MobileScannerController cameraController;

  @override
  void initState() {
    cameraController = MobileScannerController(
      returnImage: true,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            color: theme.backgroundColor,
            alignment: Alignment.center,
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                final barcode = capture.barcodes.firstOrNull?.rawValue;
                debugPrint(barcode);
                if (barcode == null) {
                  return;
                }

                _handleScanResult(barcode, (message, statusCode, ticketName) {
                  Navigator.pop(context);
                  if (statusCode == 200) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, _, __) =>
                            QrCodeScanSuccessScreen(
                          barcode: barcode,
                          status: message!,
                          eventId: widget.eventId,
                          ticketName: ticketName ?? '',
                        ),
                      ),
                    );
                  } else if (statusCode == 201) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, _, __) =>
                            QrCodeAlreadyScannedScreen(
                          barcode: barcode,
                          status: message!,
                          eventId: widget.eventId,
                          ticketName: ticketName ?? '',
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, _, __) => QrCodeScanErrorScreen(
                          barcode: barcode,
                          status: message!,
                          eventId: widget.eventId,
                        ),
                      ),
                    );
                  }
                });
              },
              overlayBuilder: (context, constraints) {
                return QRScannerOverlay();
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: kToolbarHeight,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.clear,
                      color: theme.iconColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => cameraController.toggleTorch(),
                    icon: ValueListenableBuilder(
                        builder: (context, torchState, child) => Icon(
                              torchState == TorchState.off
                                  ? Icons.flash_off
                                  : Icons.flash_on,
                              color: theme.iconColor,
                            ),
                        valueListenable: ValueNotifier(
                          cameraController.torchEnabled
                              ? TorchState.on
                              : TorchState.off,
                        )),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  void _handleScanResult(
      String barcode,
      Function(String? onScanned, int statusCode, String? name)
          onScanned) async {
    try {
      final response =
          await _eventApi.checkIn(code: barcode, eventId: widget.eventId);

      onScanned(response!.message, response.statusCode, response.name);
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }
}
