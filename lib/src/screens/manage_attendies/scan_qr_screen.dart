import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

enum CheckInOptions {
  ticket(name: 'Ticket'),
  order(name: 'Order');

  final String name;

  const CheckInOptions({required this.name});
}

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({
    super.key,
    required this.checkInOptions,
  });

  final CheckInOptions checkInOptions;

  @override
  Widget build(BuildContext context) {
    final cameraController = MobileScannerController(
      returnImage: true,
    );
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
                if (barcode == null) {
                  return;
                }
              },
              overlay: QRScannerOverlay(),
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
                      valueListenable: cameraController.torchState,
                    ),
                  ),
                  SizedBox()
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
