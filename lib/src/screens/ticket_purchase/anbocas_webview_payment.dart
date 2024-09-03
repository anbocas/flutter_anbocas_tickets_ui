import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/anbocas_flutter_ticket_booking.dart';
import 'package:anbocas_tickets_ui/src/helper/alert_mixin.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/model/anbocas_event_response.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:anbocas_tickets_ui/src/screens/ticket_purchase/anbocas_booking_success_screen.dart';
import 'package:anbocas_tickets_ui/src/model/order_response.dart';

class AnbocasWebviewPayment extends StatefulWidget {
  final OrderData orderDetails;
  final AnbocasEventResponse selectedTickets;
  final String webUrl;
  final String? referenceEventId;
  const AnbocasWebviewPayment(
      {Key? key,
      required this.orderDetails,
      required this.selectedTickets,
      required this.webUrl,
      this.referenceEventId})
      : super(key: key);

  @override
  State<AnbocasWebviewPayment> createState() => _AnbocasWebviewPaymentState();
}

class _AnbocasWebviewPaymentState extends State<AnbocasWebviewPayment>
    with AlertDialogMixin {
  late final WebViewController controller;

  ValueNotifier<bool> urlLoading = ValueNotifier(true);

  @override
  void initState() {
    super.initState();

    // #docregion webview_controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress >= 100) {
              urlLoading.value = false;
            }
          },
          onPageStarted: (String url) {
            urlLoading.value = true;
            // log("$url onPageStarted webviewwidget");
          },
          onUrlChange: (UrlChange url) {
            if (url.url!.contains("/order")) {
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnbocasBookingSuccessScreen(
                      ticketResponse: widget.selectedTickets,
                      orderDetails: widget.orderDetails,
                      referenceEventId: widget.referenceEventId,
                    ),
                  ),
                );
              }
            }
            if (url.url!.contains("/order/cancel")) {
              if (mounted) {
                Navigator.pop(context);
              }
            }
          },
          onPageFinished: (String url) {
            // log("$url onPageFinished webviewwidget");
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.webUrl));
  }

  void _handleCancel() async {
    await showAlertDialog(context, "Payment Cancel",
        "Are you sure want to cancelled the payment process?",
        okButtonText: "Yes",
        topIcon: const Icon(
          Icons.cancel,
          color: Colors.red,
        ), okPressed: () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleCancel();
        return false;
      },
      child: Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(
            backgroundColor: theme.backgroundColor,
            title: Text(
              "Payment",
              style: theme.headingStyle?.copyWith(fontWeight: FontWeight.w400),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: _handleCancel,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: Stack(
            children: [
              WebViewWidget(controller: controller),
              ValueListenableBuilder(
                  valueListenable: urlLoading,
                  builder: (context, loader, child) {
                    return loader == false
                        ? const SizedBox()
                        : Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 4.adaptSize,
                              color: theme.primaryColor,
                              backgroundColor: Colors.white,
                            ),
                          );
                  }),
            ],
          )),
    );
  }
}
