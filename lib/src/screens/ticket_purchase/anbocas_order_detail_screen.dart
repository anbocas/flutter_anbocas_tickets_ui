import 'dart:ui';

import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/logger_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/snackbar_mixin.dart';
import 'package:anbocas_tickets_ui/src/helper/string_helper_mixin.dart';
import 'package:anbocas_tickets_ui/src/screens/ticket_purchase/anbocas_qr_fullview.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_manager.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:anbocas_tickets_ui/src/model/order_response.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AnbocasOrderDetailScreen extends StatefulWidget {
  final String anbocasOrderId;
  final String? referenceEventId;
  const AnbocasOrderDetailScreen({
    Key? key,
    required this.anbocasOrderId,
    this.referenceEventId,
  }) : super(key: key);

  @override
  State<AnbocasOrderDetailScreen> createState() =>
      _AnbocasOrderDetailScreenState();
}

class _AnbocasOrderDetailScreenState extends State<AnbocasOrderDetailScreen>
    with SnackbarMixin, StringHelperMixin, LoggerUtils {
  final AnbocasBookingRepo? _booking = AnbocasServiceManager().bookingRepo;
  final ValueNotifier<OrderData?> orderResponse = ValueNotifier(null);
  final ValueNotifier<bool> loading = ValueNotifier(false);

  @override
  void initState() {
    _fetchorder();
    super.initState();
  }

  Future<void> _fetchorder() async {
    try {
      loading.value = true;

      final orderDetails =
          await _booking?.getOrderDetails(orderId: widget.anbocasOrderId);

      orderResponse.value = orderDetails;
    } catch (e) {
      error(e.toString());
    } finally {
      loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: ValueListenableBuilder<bool>(
              valueListenable: loading,
              builder: (context, isLoading, child) {
                return loading.value
                    ? Center(
                        child: CircularProgressIndicator(
                        strokeWidth: 4.adaptSize,
                        color: theme.primaryColor,
                        backgroundColor: Colors.white,
                      ))
                    : RefreshIndicator(
                        color: theme.primaryColor,
                        backgroundColor: Colors.white,
                        strokeWidth: 4.adaptSize,
                        onRefresh: () {
                          return _fetchorder();
                        },
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0.h),
                              child: Column(
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
                                              " (${orderResponse.value?.orderNumber}) ",
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
                                  SizedBox(
                                    height: 20.v,
                                  ),
                                  if (orderResponse.value?.event?.imageUrl !=
                                          null &&
                                      orderResponse.value!.event!.imageUrl!
                                          .contains("http"))
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15.0.h),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  orderResponse.value!.event!
                                                          .imageUrl ??
                                                      "",
                                                ),
                                              ),
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(),
                                              child: Image.network(
                                                orderResponse.value!.event!
                                                        .imageUrl ??
                                                    "",
                                                height: 180.v,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Image.network(
                                            orderResponse
                                                    .value!.event!.imageUrl ??
                                                "",
                                            height: 180.v,
                                            fit: BoxFit.contain,
                                          ),
                                        ],
                                      ),
                                    ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
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
                                                    orderResponse.value!.event!
                                                            .name ??
                                                        "",
                                                    style:
                                                        theme.subHeadingStyle),
                                                if (widget.referenceEventId !=
                                                    null)
                                                  TextButton(
                                                    onPressed: () {
                                                      AnbocasEventManager
                                                          .instance
                                                          .emit(
                                                              AnbocasEventManager
                                                                  .eventBookingSuccess,
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
                                                              color: theme
                                                                  .primaryColor),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3.v),
                                              child: Text(
                                                  'Booked on: ${orderResponse.value!.createdAt!}',
                                                  style: theme.labelStyle
                                                      ?.copyWith(
                                                          color: theme
                                                              .secondaryTextColor,
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
                                  Row(
                                    children: [
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: theme.iconColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.h,
                                                  vertical: 2.v),
                                              decoration: const BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(5),
                                                  )),
                                              child: Text(
                                                  DateFormatter.formatMonth(
                                                      DateTime.parse(
                                                          orderResponse
                                                                  .value!
                                                                  .event!
                                                                  .startDate ??
                                                              "")),
                                                  style: theme.labelStyle),
                                            ),
                                            Text(
                                                DateFormatter.formatDay(
                                                    DateTime.parse(orderResponse
                                                            .value!
                                                            .event!
                                                            .startDate ??
                                                        "")),
                                                style: theme.bodyStyle
                                                    ?.copyWith(
                                                        color: Colors.black))
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.h,
                                      ),
                                      Text(
                                          DateFormatter.formatTime(
                                              DateTime.parse(orderResponse
                                                      .value!
                                                      .event!
                                                      .startDate ??
                                                  "")),
                                          style: theme.bodyStyle)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.v,
                                  ),
                                  Row(
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
                                            '${orderResponse.value!.event!.venue}, ${orderResponse.value!.event!.location}',
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
                                  ...orderResponse.value!.tickets
                                      .asMap()
                                      .entries
                                      .map((e) => InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => QrFullview(
                                                          ticketCodes:
                                                              orderResponse
                                                                  .value!
                                                                  .ticketGuests(e
                                                                      .value
                                                                      .id!))));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15.v,
                                                  horizontal: 12.h),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: theme.secondaryBgColor,
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 4.h),
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
                                                          style:
                                                              theme.labelStyle),
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
                                                        WrapAlignment.start,
                                                    runAlignment:
                                                        WrapAlignment.start,
                                                    children:
                                                        orderResponse.value!
                                                            .ticketGuests(
                                                                e.value.id!)
                                                            .map(
                                                                (guest) =>
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                "${orderResponse.value!.company?.currency?.symbol ?? "\u20B9"} ${changePrice(orderResponse.value!.subTotal.toString())}",
                                                style: theme.labelStyle)
                                          ],
                                        ),
                                        if (orderResponse
                                                .value!.discountAmount >
                                            0.0)
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        if (orderResponse
                                                .value!.discountAmount >
                                            0.0)
                                          Row(
                                            children: [
                                              Text("Coupon : ",
                                                  style: theme.labelStyle),
                                              if (orderResponse.value!.coupon !=
                                                  null)
                                                Chip(
                                                  labelStyle: theme.labelStyle,
                                                  label: Text(orderResponse
                                                      .value!.coupon
                                                      .toString()),
                                                  backgroundColor:
                                                      theme.primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        color: Colors
                                                            .black), // Border color
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                ),
                                              SizedBox(
                                                width: 10.h,
                                              ),
                                              const Spacer(),
                                              Text(
                                                "- ${orderResponse.value!.company?.currency?.symbol ?? "\u20B9"} ${changePrice(orderResponse.value!.discountAmount.toString())}",
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
                                      decoration: BoxDecoration(
                                          color: theme.secondaryBgColor
                                              ?.withAlpha(80)),
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
                                              "${orderResponse.value!.company?.currency?.symbol ?? "\u20B9"} ${changePrice(orderResponse.value!.totalPayable.toString())}",
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
                      );
              }),
        ));
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
