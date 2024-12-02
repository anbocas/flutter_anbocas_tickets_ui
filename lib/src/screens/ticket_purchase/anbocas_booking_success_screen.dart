// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/snackbar_mixin.dart';
import 'package:anbocas_tickets_ui/src/helper/string_helper_mixin.dart';
import 'package:anbocas_tickets_ui/src/model/anbocas_event_response.dart';
import 'package:anbocas_tickets_ui/src/model/order_response.dart';
import 'package:anbocas_tickets_ui/src/screens/ticket_purchase/anbocas_qr_fullview.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_manager.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_repo.dart';

class AnbocasBookingSuccessScreen extends StatefulWidget {
  final OrderData orderDetails;
  final String? referenceEventId;
  final bool detailFlow;
  const AnbocasBookingSuccessScreen(
      {Key? key,
      required this.orderDetails,
      this.referenceEventId,
      this.detailFlow = false})
      : super(key: key);

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

  final ValueNotifier<OrderData?> _orderDetails =
      ValueNotifier<OrderData?>(null);

  @override
  void initState() {
    super.initState();
    _orderDetails.value = widget.orderDetails;
    if (widget.detailFlow == false) {
      _startPolling();
    } else {
      _updateTheOrderForDetailFlow();
    }
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
          AnbocasEventManager.instance
              .emit(AnbocasEventManager.eventBookingSuccess, {
            ..._orderDetails.value!.trimmedPayload(),
            'reference_event_id': widget.referenceEventId
          });

          if (mounted) {
            setState(() {});
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
      if (orderDetails.data != null) {
        _orderDetails.value = orderDetails.data;
        return orderDetails.data?.status ?? "PENDING";
      }
      return "PENDING";
    }
  }

  void _updateTheOrderForDetailFlow() async {
    final orderDetails =
        await _booking?.getOrderDetails(orderId: widget.orderDetails.id ?? "");
    if (orderDetails != null && orderDetails.data != null) {
      _statusNotifier.value = orderDetails.data?.status ?? "PENDING";
      _orderDetails.value = orderDetails.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                                if (widget.detailFlow && status == 'PENDING') {
                                  return const SizedBox.shrink();
                                } else if (status == 'COMPLETED') {
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
                                        height: 10.v,
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
                                        size: 50,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        height: 10.v,
                                      ),
                                      Text(
                                        "Your order has failed.",
                                        style: theme.bodyStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  );
                                } else if (status == 'CANCELLED') {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 10.v,
                                      ),
                                      const Icon(
                                        Icons.cancel_outlined,
                                        size: 50,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        height: 10.v,
                                      ),
                                      Text(
                                        "Your order is cancelled.",
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
                                        widget.detailFlow == true
                                            ? const Icon(
                                                Icons.pending,
                                                size: 50,
                                                color: Colors.yellow,
                                              )
                                            : CircularProgressIndicator(
                                                strokeWidth: 4.adaptSize,
                                                color: theme.accentColor,
                                                backgroundColor: Colors.white,
                                              ),
                                        SizedBox(
                                          height: 10.v,
                                        ),
                                        Text(
                                          "Order Status ${_statusNotifier.value}",
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              _orderDetails
                                                      .value!.event?.name ??
                                                  "",
                                              style: theme.subHeadingStyle),
                                          if (widget.referenceEventId != null)
                                            TextButton(
                                              onPressed: () {
                                                AnbocasEventManager.instance
                                                    .emit(
                                                        AnbocasEventManager
                                                            .viewEvent,
                                                        {
                                                      'event_id': widget
                                                          .referenceEventId,
                                                    });
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'View Event',
                                                style: theme.labelStyle
                                                    ?.copyWith(
                                                        color:
                                                            theme.primaryColor),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.v),
                                        child: Text(
                                            'Order Date: ${_orderDetails.value!.createdAt!}',
                                            style: theme.labelStyle?.copyWith(
                                                color: theme.secondaryTextColor,
                                                fontSize: 12.fSize)),
                                      ),
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
                            ValueListenableBuilder<OrderData?>(
                                valueListenable: _orderDetails,
                                builder: (context, value, child) {
                                  return (value != null &&
                                          value.event != null &&
                                          value.event?.startDate != null)
                                      ? Row(
                                          children: [
                                            DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: theme.iconColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.h,
                                                            vertical: 2.v),
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .vertical(
                                                              top: Radius
                                                                  .circular(5),
                                                            )),
                                                    child: Text(
                                                        DateFormatter.formatMonth(
                                                            DateTime.parse(value
                                                                    .event!
                                                                    .startDate ??
                                                                "")),
                                                        style:
                                                            theme.labelStyle),
                                                  ),
                                                  Text(
                                                      DateFormatter.formatDay(
                                                          DateTime.parse(value
                                                                  .event!
                                                                  .startDate ??
                                                              "")),
                                                      style: theme.bodyStyle
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.black))
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.h,
                                            ),
                                            Text(
                                                DateFormatter.formatTime(
                                                    DateTime.parse(value
                                                            .event!.startDate ??
                                                        "")),
                                                style: theme.bodyStyle)
                                          ],
                                        )
                                      : const SizedBox.shrink();
                                }),
                            SizedBox(
                              height: 10.v,
                            ),
                            ValueListenableBuilder<OrderData?>(
                              builder: (context, value, child) {
                                return (value != null && value.event != null)
                                    ? (value.event?.getLocationType() ==
                                            TicketLocationType.virtual)
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.h,
                                                    vertical: 8.v),
                                                decoration: BoxDecoration(
                                                    color: theme.iconColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
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
                                                        await Clipboard.setData(
                                                                ClipboardData(
                                                                    text: value
                                                                            .event!
                                                                            .meetingLink ??
                                                                        "N/A"))
                                                            .then((value) =>
                                                                showSnackBar(
                                                                    context,
                                                                    "Link Copied"));
                                                      },
                                                      child: Text(
                                                          value.event
                                                                  ?.meetingLink ??
                                                              "N/A",
                                                          style:
                                                              theme.bodyStyle),
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
                                                    horizontal: 10.h,
                                                    vertical: 8.v),
                                                decoration: BoxDecoration(
                                                    color: theme.iconColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
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
                                                    value.event?.location ?? "",
                                                    style: theme.bodyStyle),
                                              )
                                            ],
                                          )
                                    : const SizedBox.shrink();
                              },
                              valueListenable: _orderDetails,
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
                            ValueListenableBuilder<OrderData?>(
                                valueListenable: _orderDetails,
                                builder: (context, value, child) {
                                  return value != null
                                      ? Column(
                                          children: value.tickets
                                              .asMap()
                                              .entries
                                              .map((e) => InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => QrFullview(
                                                                  ticketCodes: value
                                                                      .ticketGuests(e
                                                                          .value
                                                                          .id!))));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 15.v,
                                                              horizontal: 12.h),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: theme
                                                            .secondaryBgColor,
                                                      ),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4.h),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "${e.key + 1}. ",
                                                                style: theme
                                                                    .subHeadingStyle,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                    e.value.singleTicket
                                                                            ?.name ??
                                                                        "",
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: theme
                                                                        .subHeadingStyle),
                                                              ),
                                                              SizedBox(
                                                                width: 10.h,
                                                              ),
                                                              Text(
                                                                  "${e.value.quantity}x",
                                                                  style: theme
                                                                      .labelStyle),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10.v,
                                                          ),
                                                          Wrap(
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .start,
                                                            alignment:
                                                                WrapAlignment
                                                                    .start,
                                                            runAlignment:
                                                                WrapAlignment
                                                                    .start,
                                                            children: value
                                                                // .guests
                                                                .ticketGuests(
                                                                    e.value.id!)
                                                                .map((guest) =>
                                                                    SizedBox(
                                                                      width: 70,
                                                                      child:
                                                                          QrImageView(
                                                                        data:
                                                                            guest,
                                                                        version:
                                                                            QrVersions.auto,
                                                                        dataModuleStyle: QrDataModuleStyle(
                                                                            dataModuleShape:
                                                                                QrDataModuleShape.square,
                                                                            color: theme.qrcodeColor),
                                                                        eyeStyle: QrEyeStyle(
                                                                            eyeShape:
                                                                                QrEyeShape.square,
                                                                            color: theme.qrcodeColor),
                                                                      ),
                                                                    ))
                                                                .toList(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        )
                                      : const SizedBox.shrink();
                                }),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.v,
                      ),
                      const Divider(),
                      ValueListenableBuilder(
                          valueListenable: _orderDetails,
                          builder: (context, value, child) {
                            return value != null
                                ? PaymentOverviewWidget(
                                    order: value,
                                  )
                                : SizedBox.fromSize();
                          })
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class PaymentOverviewWidget extends StatelessWidget with StringHelperMixin {
  final OrderData order;
  const PaymentOverviewWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: theme.secondaryBgColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.h, vertical: 10.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Payment Overview:", style: theme.subHeadingStyle),
                SizedBox(
                  height: 20.v,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sub Total",
                      style: theme.labelStyle,
                    ),
                    Text(
                        "${order.company?.currency?.symbol ?? "\u20B9"} ${changePrice(order.subTotal.toString())}",
                        style: theme.labelStyle)
                  ],
                ),
                if (order.discountAmount > 0.0)
                  const SizedBox(
                    height: 5,
                  ),
                if (order.discountAmount > 0.0)
                  Row(
                    children: [
                      Text("Coupon : ", style: theme.labelStyle),
                      if (order.coupon != null)
                        Chip(
                          labelStyle: theme.labelStyle,
                          label: Text(order.coupon.toString()),
                          backgroundColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.black), // Border color
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      SizedBox(
                        width: 10.h,
                      ),
                      const Spacer(),
                      Text(
                        "- ${order.company?.currency?.symbol ?? "\u20B9"} ${changePrice(order.discountAmount.toString())}",
                        style: theme.labelStyle,
                      )
                    ],
                  ),
                // SizedBox(
                //   height: 5.v,
                // ),
              ],
            ),
          ),
          DecoratedBox(
              decoration:
                  BoxDecoration(color: theme.secondaryBgColor?.withAlpha(80)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 10.v),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Amount Paid", style: theme.labelStyle),
                    Text(
                      "${order.company?.currency?.symbol ?? "\u20B9"} ${changePrice(order.totalPayable.toString())}",
                      style: theme.labelStyle,
                    )
                  ],
                ),
              )),
        ],
      ),
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
    // String secondStr = dateTime.second.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr $period';
  }

  static String formatDate(DateTime dateTime) {
    final month = formatMonth(dateTime);
    final day = formatDay(dateTime);
    final year = dateTime.year;
    final time = formatTime(dateTime);
    return '$month $day, $year $time';
  }
}
