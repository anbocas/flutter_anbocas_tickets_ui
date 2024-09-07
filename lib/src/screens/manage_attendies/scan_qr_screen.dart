import 'package:anbocas_tickets_api/anbocas_tickets_api.dart';
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

                _handleScanResult(barcode, (message, statusCode) {
                  if (statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        message ?? '',
                        style: const TextStyle(color: Colors.black),
                      ),
                      backgroundColor: Colors.green,
                    ));
                    Navigator.pop(context, {});
                  } else if (statusCode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        message ?? '',
                        style: const TextStyle(color: Colors.black),
                      ),
                      backgroundColor: Colors.amber,
                    ));
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          message ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    Navigator.pop(context);
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

  void _handleScanResult(String barcode,
      Function(String? onScanned, int statusCode) onScanned) async {
    try {
      final response =
          await _eventApi.checkIn(code: barcode, eventId: widget.eventId);

      onScanned(response!.message, response.statusCode);
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }
}
