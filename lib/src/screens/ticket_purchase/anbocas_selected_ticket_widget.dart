import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/components/add_coupon_widget.dart';
import 'package:anbocas_tickets_ui/src/helper/logger_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/string_helper_mixin.dart';
import 'package:flutter/material.dart';
import 'package:anbocas_tickets_ui/src/screens/ticket_purchase/anbocas_payment_widget.dart';
import 'package:anbocas_tickets_ui/src/components/custom_button.dart';
import 'package:anbocas_tickets_ui/src/components/ticket_single_item.dart';
import 'package:anbocas_tickets_ui/src/helper/alert_mixin.dart';
import 'package:anbocas_tickets_ui/src/helper/snackbar_mixin.dart';
import 'package:anbocas_tickets_ui/src/model/order_response.dart';
import 'package:anbocas_tickets_ui/src/model/single_ticket.dart';
import 'package:anbocas_tickets_ui/src/model/anbocas_event_response.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_manager.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_repo.dart';

class AnbocasSelectedTicketWidget extends StatefulWidget {
  final AnbocasEventResponse ticketResponse;
  final String eventId;
  const AnbocasSelectedTicketWidget(
      {Key? key, required this.ticketResponse, required this.eventId})
      : super(key: key);

  @override
  State<AnbocasSelectedTicketWidget> createState() =>
      _AnbocasSelectedTicketWidgetState();
}

class _AnbocasSelectedTicketWidgetState
    extends State<AnbocasSelectedTicketWidget>
    with AlertDialogMixin, SnackbarMixin, StringHelperMixin, LoggerUtils {
  ValueNotifier<double> itemsTotal = ValueNotifier(0.00);
  ValueNotifier<double> totalPrice = ValueNotifier(0.00);
  ValueNotifier<double> totalFee = ValueNotifier(0.00);
  ValueNotifier<double> discountPrice = ValueNotifier(0.00);
  List<SingleTicket> selectedTickets = [];
  final AnbocasBookingRepo? _booking = AnbocasServiceManager().bookingRepo;

  @override
  void initState() {
    selectedTickets.clear();
    selectedTickets.addAll(widget.ticketResponse.tickets);
    fetchCalculatedAmount();
    super.initState();
  }

  @override
  void dispose() {
    selectedTickets.clear();
    super.dispose();
  }

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  void fetchCalculatedAmount() async {
    selectedTickets.asMap().forEach((key, value) {
      info(value.selectedQuantity.toString());
    });
    try {
      isLoading.value = true;
      await _booking
          ?.getCalculateAmount(
              selectedTickets: selectedTickets, coupon: appliedCoupon)
          .then((value) {
        if (value != null) {
          updateTheValue(value);
        } else {
          showAlertSnackBar(context, "Unable to update price");
        }
      }).whenComplete(() => isLoading.value = false);
    } catch (e) {
      isLoading.value = false;
    }
  }

  void updateTheValue(OrderResponse order) {
    info(order.data.toString());
    itemsTotal.value = order.data?.subTotal ?? 0.00;
    totalFee.value = order.data?.totalConvenienceFee ?? 0.00;
    totalPrice.value = order.data?.totalPayable ?? 0.00;
    discountPrice.value = order.data?.discountAmount ?? 0.00;
  }

  String? appliedCoupon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          backgroundColor: theme.backgroundColor,
          title: Text(
            "Ticket Booking",
            style: theme.headingStyle?.copyWith(fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: _iconBack(theme.iconColor!),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.separated(
              shrinkWrap: true,
              itemCount: selectedTickets.length,
              padding: EdgeInsets.fromLTRB(22.h, 0, 22.h, 10.v),
              itemBuilder: (context, index) {
                var element = selectedTickets[index];
                return TicketItemWidget(
                  
                  isSelected: true,
                  element: element,
                  showDeleteIcon: true,
                  onDeletePres: () {
                    showAlertDialog(context, "Delete Confirmation",
                        "Are you sure want to unselect this ticket",
                        okPressed: () {
                      if (selectedTickets.length > 1) {
                        selectedTickets.remove(element);
                        setState(() {});

                        fetchCalculatedAmount();
                      } else {
                        Navigator.pop(context);
                      }
                    });
                  },
                  onQuantityChanged: (newQuantity, ticketId) {
                    element.selectedQuantity = newQuantity;
                    fetchCalculatedAmount();
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: theme.dividerColor,
                );
              },
            )),
            Visibility(
              visible: selectedTickets.isNotEmpty,
              child: ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context, loading, child) {
                    return loading == true
                        ? SizedBox(
                            height: 100.v,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: theme.accentColor,
                              ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            color: theme.secondaryBgColor,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.0.h, vertical: 20.v),
                                  child: Column(
                                    children: [
                                      ValueListenableBuilder(
                                          valueListenable: itemsTotal,
                                          builder: (context, value, child) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Sub Total",
                                                  style: theme.labelStyle
                                                      ?.copyWith(
                                                    fontSize: 15.fSize,
                                                    color: theme
                                                        .secondaryTextColor,
                                                  ),
                                                ),
                                                Text(
                                                    "${widget.ticketResponse.company?.currency?.symbol ?? "\u20B9"} ${changePrice(value.toString())}",
                                                    style: theme.labelStyle)
                                              ],
                                            );
                                          }),
                                      SizedBox(
                                        height: 8.v,
                                      ),
                                      ValueListenableBuilder(
                                          valueListenable: totalFee,
                                          builder: (context, value, child) {
                                            return value > 0
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Convenience Fee",
                                                        style: theme.labelStyle
                                                            ?.copyWith(
                                                          fontSize: 15.fSize,
                                                          color: theme
                                                              .secondaryTextColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${widget.ticketResponse.company?.currency?.symbol ?? "\u20B9"} ${changePrice(value.toString())}",
                                                        style: theme.labelStyle,
                                                      )
                                                    ],
                                                  )
                                                : const SizedBox.shrink();
                                          }),
                                      SizedBox(
                                        height: 8.v,
                                      ),
                                      appliedCoupon == null
                                          ? InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    useSafeArea: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    builder: (context) {
                                                      return AddCouponWidget(
                                                        eventId: widget.eventId,
                                                        totalAmount:
                                                            totalPrice.value,
                                                        validatedCoupon:
                                                            (String value,
                                                                double price) {
                                                          appliedCoupon = value;
                                                          Navigator.of(context)
                                                              .pop();
                                                          fetchCalculatedAmount();
                                                        },
                                                      );
                                                    });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5.0.v),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Add Coupon",
                                                      style: theme.labelStyle
                                                          ?.copyWith(
                                                        fontSize: 15.fSize,
                                                        color: theme
                                                            .secondaryTextColor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.h,
                                                    ),
                                                    Icon(
                                                      Icons.add,
                                                      color: theme
                                                          .secondaryIconColor,
                                                      size: 18.adaptSize,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Row(
                                              children: [
                                                Text(
                                                  "Coupon : ",
                                                  style: theme.labelStyle
                                                      ?.copyWith(
                                                    fontSize: 15.fSize,
                                                    color: theme
                                                        .secondaryTextColor,
                                                  ),
                                                ),
                                                Chip(
                                                  label: Text(
                                                      appliedCoupon.toString()),
                                                  deleteIcon: Icon(Icons.close,
                                                      color: theme.iconColor),
                                                  onDeleted: () {
                                                    appliedCoupon = null;
                                                    fetchCalculatedAmount();
                                                  },
                                                  deleteIconColor: Colors.white,
                                                  backgroundColor:
                                                      theme.accentColor,
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
                                                  "- ${widget.ticketResponse.company?.currency?.symbol ?? "\u20B9"} ${changePrice(discountPrice.value.toString())}",
                                                  style: theme.labelStyle,
                                                )
                                              ],
                                            )
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
                                      child: ValueListenableBuilder(
                                          valueListenable: totalPrice,
                                          builder: (context, value, child) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Total Payable",
                                                  style: theme.labelStyle
                                                      ?.copyWith(
                                                    fontSize: 15.fSize,
                                                    color: theme
                                                        .secondaryTextColor,
                                                  ),
                                                ),
                                                Text(
                                                  "${widget.ticketResponse.company?.currency?.symbol ?? "\u20B9"} ${changePrice(value.toString())}",
                                                  style: theme.labelStyle,
                                                )
                                              ],
                                            );
                                          }),
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.h, vertical: 20.v),
                                  child: CustomButton(
                                      onPressedCallback: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AnbocasPaymentWidget(
                                                      appliedCouponCode:
                                                          appliedCoupon,
                                                      eventResponse: widget
                                                          .ticketResponse
                                                          .copyWithSelectedTickets(
                                                              tickets:
                                                                  selectedTickets),
                                                      itemTotal:
                                                          totalPrice.value,
                                                      totalFee: totalFee.value,
                                                      discountPrice:
                                                          discountPrice.value,
                                                      totalPrice:
                                                          totalPrice.value,
                                                    )),
                                          ),
                                      centerText: "Checkout"),
                                ),
                              ],
                            ),
                          );
                  }),
            )
          ],
        ));
  }

  Icon _iconBack(Color color) =>
      Theme.of(context).platform == TargetPlatform.iOS
          ? Icon(
              Icons.arrow_back_ios,
              color: color,
            )
          : Icon(
              Icons.arrow_back,
              color: color,
            );
}
