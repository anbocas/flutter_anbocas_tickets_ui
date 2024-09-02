import 'dart:async';

import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/components/custom_button.dart';
import 'package:anbocas_tickets_ui/src/components/ticket_card_clipper.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/snackbar_mixin.dart';
import 'package:anbocas_tickets_ui/src/helper/string_helper_mixin.dart';
import 'package:anbocas_tickets_ui/src/model/anbocas_event_response.dart';
import 'package:anbocas_tickets_ui/src/screens/ticket_purchase/qr_fullview.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_manager.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:anbocas_tickets_ui/src/model/order_response.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AnbocasBookingSuccessScreen extends StatefulWidget {
  final OrderData orderDetails;

  final AnbocasEventResponse ticketResponse;
  const AnbocasBookingSuccessScreen({
    Key? key,
    required this.orderDetails,
    required this.ticketResponse,
  }) : super(key: key);

  @override
  State<AnbocasBookingSuccessScreen> createState() =>
      _AnbocasBookingSuccessScreenState();
}

class _AnbocasBookingSuccessScreenState
    extends State<AnbocasBookingSuccessScreen>
    with SnackbarMixin, StringHelperMixin {
  bool _isPollingActive = true;
  final AnbocasBookingRepo? _booking = AnbocasServiceManager().bookingRepo;
  final ValueNotifier<String> _statusNotifier =
      ValueNotifier<String>('PENDING');
  OrderData? updateOrderResponse;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _isPollingActive = false;
    super.dispose();
  }

  Future<void> _startPolling() async {
    while (_isPollingActive) {
      final status = await _fetchStatus();
      _statusNotifier.value = status;

      if (status == 'COMPLETED' || status == 'FAILED') {
        // fire eventBookingSuccess event if order is completed
        if (status == 'COMPLETED') {
          if (mounted) {
            setState(() {});
            AnbocasEventManager().emit(AnbocasEventManager.eventBookingSuccess,
                updateOrderResponse?.trimmedPayload());
          }
        }
        break;
      }

      await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<String> _fetchStatus() async {
    final orderDetails =
        await _booking?.getOrderDetails(orderId: widget.orderDetails.id ?? "");
    if (orderDetails == null) {
      return "PENDING";
    } else {
      updateOrderResponse = orderDetails;
      return orderDetails.status ?? "PENDING";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pop(context);

        return true;
      },
      child: Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(
            backgroundColor: theme.backgroundColor,
            title: Text(
              "Order Summary",
              style: theme.headingStyle,
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: theme.iconColor,
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0.h),
                        child: Column(
                          children: [
                            ValueListenableBuilder<String>(
                              valueListenable: _statusNotifier,
                              builder: (context, status, child) {
                                if (status == 'COMPLETED') {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 10.v,
                                      ),
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 90.adaptSize,
                                      ),
                                      SizedBox(
                                        height: 20.v,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: "Congratulations! Your order",
                                          style: theme.bodyStyle,
                                          children: [
                                            TextSpan(
                                              text:
                                                  " (${widget.orderDetails.orderNumber}) ",
                                              style: theme.bodyStyle,
                                            ),
                                            TextSpan(
                                                text:
                                                    "has been placed successfully.",
                                                style: theme.bodyStyle),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  );
                                } else if (status == 'FAILED') {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 10.v,
                                      ),
                                      const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        height: 20.v,
                                      ),
                                      Text(
                                        "Unfortunately, your order has failed.",
                                        style: theme.bodyStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10.v,
                                        ),
                                        const CircularProgressIndicator(),
                                        SizedBox(
                                          height: 20.v,
                                        ),
                                        Text(
                                          "Order Status Pending",
                                          style: theme.bodyStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: 20.v,
                            ),
                            if (widget.ticketResponse.imageUrl != null &&
                                widget.ticketResponse.imageUrl!
                                    .contains("http"))
                              Padding(
                                padding: EdgeInsets.only(bottom: 15.0.h),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      widget.ticketResponse.imageUrl ?? "",
                                      height: 180.v,
                                      fit: BoxFit.fill,
                                    )),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.ticketResponse.name ?? "",
                                          style: theme.subHeadingStyle),
                                      SizedBox(
                                        height: 5.v,
                                      ),
                                      widget.ticketResponse.location != null
                                          ? RichText(
                                              text: TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0.h),
                                                      child: Icon(
                                                        Icons.pin_drop,
                                                        size: 16.adaptSize,
                                                        color:
                                                            theme.accentColor,
                                                      ),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: widget.ticketResponse
                                                            .location ??
                                                        "",
                                                    style: theme.bodyStyle,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Text(
                                              widget.ticketResponse.venue ?? "",
                                              style: theme.bodyStyle),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10.h,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.v,
                            ),
                            Row(
                              children: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: theme.iconColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.h, vertical: 2.v),
                                        decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(5),
                                            )),
                                        child: Text(
                                            DateFormatter.formatMonth(
                                                DateTime.parse(widget
                                                        .ticketResponse
                                                        .startDate ??
                                                    "")),
                                            style: theme.labelStyle),
                                      ),
                                      Text(
                                          DateFormatter.formatDay(
                                              DateTime.parse(widget
                                                      .ticketResponse
                                                      .startDate ??
                                                  "")),
                                          style: theme.bodyStyle
                                              ?.copyWith(color: Colors.black))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10.h,
                                ),
                                Text(
                                    DateFormatter.formatTime(DateTime.parse(
                                        widget.ticketResponse.startDate ?? "")),
                                    style: theme.bodyStyle)
                              ],
                            ),
                            SizedBox(
                              height: 10.v,
                            ),
                            (widget.ticketResponse.getLocationType() ==
                                    TicketLocationType.virtual)
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.h, vertical: 8.v),
                                        decoration: BoxDecoration(
                                            color: theme.iconColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Icon(
                                          Icons.video_chat_sharp,
                                          color: theme.secondaryBgColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.h,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Meeting link",
                                                style: theme.bodyStyle),
                                            GestureDetector(
                                              onLongPress: () async {
                                                await Clipboard.setData(ClipboardData(
                                                        text: widget
                                                                .ticketResponse
                                                                .meetingLink ??
                                                            "N/A"))
                                                    .then((value) =>
                                                        showSnackBar(context,
                                                            "Link Copied"));
                                              },
                                              child: Text(
                                                  widget.ticketResponse
                                                          .meetingLink ??
                                                      "N/A",
                                                  style: theme.bodyStyle),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.h, vertical: 8.v),
                                        decoration: BoxDecoration(
                                            color: theme.iconColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Icon(
                                          Icons.location_on,
                                          color: theme.secondaryBgColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.h,
                                      ),
                                      Expanded(
                                        child: Text(
                                            widget.ticketResponse.location ??
                                                "",
                                            style: theme.bodyStyle),
                                      )
                                    ],
                                  ),
                            SizedBox(
                              height: 20.v,
                            ),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                SizedBox(
                                  width: 10.h,
                                ),
                                Text("Tickets", style: theme.bodyStyle),
                                SizedBox(
                                  width: 10.h,
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            SizedBox(
                              height: 10.v,
                            ),
                            if (updateOrderResponse != null)
                              ...updateOrderResponse!.tickets
                                  .asMap()
                                  .entries
                                  .map((e) => Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.v, horizontal: 12.h),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: theme.secondaryBgColor,
                                        ),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${e.key + 1}. ",
                                                  style: theme.subHeadingStyle,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      e.value.singleTicket
                                                              ?.name ??
                                                          "",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: theme
                                                          .subHeadingStyle),
                                                ),
                                                SizedBox(
                                                  width: 10.h,
                                                ),
                                                Text("${e.value.quantity}x",
                                                    style: theme.labelStyle),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.v,
                                            ),
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              alignment: WrapAlignment.start,
                                              runAlignment: WrapAlignment.start,
                                              children: updateOrderResponse!
                                                  // .guests
                                                  .ticketGuests(e.value.id!)
                                                  .map((guest) => InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      QrFullview(
                                                                          ticketCode:
                                                                              guest)));
                                                        },
                                                        child: SizedBox(
                                                          width: 70,
                                                          child: QrImageView(
                                                            data: guest,
                                                            version:
                                                                QrVersions.auto,
                                                            dataModuleStyle: QrDataModuleStyle(
                                                                dataModuleShape:
                                                                    QrDataModuleShape
                                                                        .square,
                                                                color: theme
                                                                    .qrcodeColor),
                                                            eyeStyle: QrEyeStyle(
                                                                eyeShape:
                                                                    QrEyeShape
                                                                        .square,
                                                                color: theme
                                                                    .qrcodeColor),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.v,
                      ),
                      const Divider(),
                      Container(
                        width: double.infinity,
                        color: theme.secondaryBgColor,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.0.h, vertical: 10.v),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Payment Overview:",
                                      style: theme.subHeadingStyle),
                                  SizedBox(
                                    height: 20.v,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Sub Total",
                                        style: theme.labelStyle,
                                      ),
                                      Text(
                                          "${widget.ticketResponse.company?.currency?.symbol ?? "\u20B9"} ${changePrice(widget.orderDetails.subTotal.toString())}",
                                          style: theme.labelStyle)
                                    ],
                                  ),
                                  if (widget.orderDetails.discountAmount > 0.0)
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  if (widget.orderDetails.discountAmount > 0.0)
                                    Row(
                                      children: [
                                        Text("Coupon : ",
                                            style: theme.labelStyle),
                                        if (widget.orderDetails.coupon != null)
                                          Chip(
                                            label: Text(widget
                                                .orderDetails.coupon
                                                .toString()),
                                            backgroundColor: theme.accentColor,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors
                                                      .black), // Border color
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        SizedBox(
                                          width: 10.h,
                                        ),
                                        const Spacer(),
                                        Text(
                                          "- ${widget.ticketResponse.company?.currency?.symbol ?? "\u20B9"} ${changePrice(widget.orderDetails.discountAmount.toString())}",
                                          style: theme.labelStyle,
                                        )
                                      ],
                                    ),
                                  SizedBox(
                                    height: 5.v,
                                  ),
                                ],
                              ),
                            ),
                            DecoratedBox(
                                decoration: BoxDecoration(
                                    color:
                                        theme.secondaryBgColor?.withAlpha(80)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.h, vertical: 10.v),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total Amount Paid",
                                          style: theme.labelStyle),
                                      Text(
                                        "${widget.ticketResponse.company?.currency?.symbol ?? "\u20B9"} ${changePrice(widget.orderDetails.totalPayable.toString())}",
                                        style: theme.labelStyle,
                                      )
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Padding(
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 24.h, vertical: 20.v),
                //     child: CustomButton(
                //         onPressedCallback: () {
                //           Navigator.pop(context);
                //           Navigator.pop(context);
                //         },
                //         centerText: "Back to Event")),
              ],
            ),
          )),
    );
  }
}

class DateFormatter {
  static String formatMonth(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[dateTime.month - 1];
  }

  static String formatDay(DateTime dateTime) {
    return '${dateTime.day}';
  }

  static String formatTime(DateTime dateTime) {
    String period = 'AM';
    int hour = dateTime.hour;
    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) hour -= 12;
    }
    String hourStr = hour.toString().padLeft(2, '0');
    String minuteStr = dateTime.minute.toString().padLeft(2, '0');
    String secondStr = dateTime.second.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr:$secondStr $period';
  }

  static String formatDate(DateTime dateTime) {
    final month = formatMonth(dateTime);
    final day = formatDay(dateTime);
    final year = dateTime.year;
    final time = formatTime(dateTime);
    return '$month $day, $year $time';
  }
}
