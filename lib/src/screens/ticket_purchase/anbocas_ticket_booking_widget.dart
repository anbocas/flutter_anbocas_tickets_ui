import 'package:anbocas_tickets_ui/src/anbocas_flutter_ticket_booking.dart';
import 'package:anbocas_tickets_ui/src/components/add_coupon_widget.dart';
import 'package:anbocas_tickets_ui/src/helper/logger_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/snackbar_mixin.dart';
import 'package:anbocas_tickets_ui/src/helper/string_helper_mixin.dart';
import 'package:anbocas_tickets_ui/src/model/order_response.dart';
import 'package:anbocas_tickets_ui/src/screens/ticket_purchase/anbocas_payment_widget.dart';
import 'package:anbocas_tickets_ui/src/screens/ticket_purchase/anbocas_selected_ticket_widget.dart';
import 'package:anbocas_tickets_ui/src/components/custom_button.dart';
import 'package:anbocas_tickets_ui/src/components/ticket_single_item.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/model/single_ticket.dart';
import 'package:anbocas_tickets_ui/src/model/anbocas_event_response.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_manager.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_repo.dart';
import 'package:flutter/material.dart';

class AnbocasTicketBookingWidget extends StatefulWidget {
  final bool allowGroupTicket;
  final String eventId;
  const AnbocasTicketBookingWidget(
      {Key? key, required this.allowGroupTicket, required this.eventId})
      : super(key: key);

  @override
  State<AnbocasTicketBookingWidget> createState() =>
      _AnbocasTicketBookingWidgetState();

  static AnbocasTicketBookingState? of(BuildContext context) =>
      context.findAncestorStateOfType<AnbocasTicketBookingState>();
}

class _AnbocasTicketBookingWidgetState extends AnbocasTicketBookingState
    with LoggerUtils, SnackbarMixin, StringHelperMixin {
  ValueNotifier<double> itemsTotal = ValueNotifier(0.00);
  ValueNotifier<double> totalPrice = ValueNotifier(0.00);
  ValueNotifier<double> totalFee = ValueNotifier(0.00);
  ValueNotifier<double> discountPrice = ValueNotifier(0.00);
  ValueNotifier<bool> calculatingSummary = ValueNotifier(false);
  AnbocasEventResponse? ticketResponse;

  void updateTheValue(OrderResponse order) {
    info(order.data.toString());
    itemsTotal.value = order.data?.subTotal ?? 0.00;
    totalFee.value = order.data?.totalConvenienceFee ?? 0.00;
    totalPrice.value = order.data?.totalPayable ?? 0.00;
    discountPrice.value = order.data?.discountAmount ?? 0.00;
  }

  String? appliedCoupon;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    itemsTotal.dispose();
    totalFee.dispose();
    totalPrice.dispose();
    discountPrice.dispose();
    super.dispose();
  }

  void fetchCalculatedAmount() async {
    selectedTickets.asMap().forEach((key, value) {
      info(value.selectedQuantity.toString());
    });
    try {
      calculatingSummary.value = true;
      await _booking
          ?.getCalculateAmount(
              selectedTickets: selectedTickets, coupon: appliedCoupon)
          .then((value) {
        if (value != null) {
          updateTheValue(value);
        } else {
          showAlertSnackBar(context, "Unable to update price");
        }
      }).whenComplete(() => calculatingSummary.value = false);
    } catch (e) {
      calculatingSummary.value = false;
    }
  }

  Center _buildLoader() {
    return Center(
        child: CircularProgressIndicator.adaptive(
      backgroundColor: theme.accentColor,
    ));
  }

  Widget _buildSummary() {
    if (selectedTickets.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return ValueListenableBuilder(
          valueListenable: calculatingSummary,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.v),
                    width: double.infinity,
                    color: theme.secondaryBgColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            ValueListenableBuilder(
                                valueListenable: itemsTotal,
                                builder: (context, value, child) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Sub Total",
                                        style: theme.labelStyle?.copyWith(
                                          fontSize: 15.fSize,
                                          color: theme.secondaryTextColor,
                                        ),
                                      ),
                                      Text(
                                          "${ticketResponse?.company?.currency?.symbol ?? "\u20B9"} ${changePrice(value.toString())}",
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Convenience Fee",
                                              style: theme.labelStyle?.copyWith(
                                                fontSize: 15.fSize,
                                                color: theme.secondaryTextColor,
                                              ),
                                            ),
                                            Text(
                                              "${ticketResponse?.company?.currency?.symbol ?? "\u20B9"} ${changePrice(value.toString())}",
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
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            return AddCouponWidget(
                                              eventId: widget.eventId,
                                              totalAmount: totalPrice.value,
                                              validatedCoupon:
                                                  (String value, double price) {
                                                appliedCoupon = value;
                                                Navigator.of(context).pop();
                                                fetchCalculatedAmount();
                                              },
                                            );
                                          });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Add Coupon",
                                          style: theme.labelStyle?.copyWith(
                                            fontSize: 15.fSize,
                                            color: theme.secondaryTextColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.h,
                                        ),
                                        Icon(
                                          Icons.add,
                                          color: theme.secondaryIconColor,
                                          size: 18.adaptSize,
                                        ),
                                      ],
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        "Coupon : ",
                                        style: theme.labelStyle?.copyWith(
                                          fontSize: 15.fSize,
                                          color: theme.secondaryTextColor,
                                        ),
                                      ),
                                      Chip(
                                        label: Text(appliedCoupon.toString()),
                                        deleteIcon: Icon(Icons.close,
                                            color: theme.iconColor),
                                        onDeleted: () {
                                          appliedCoupon = null;
                                          fetchCalculatedAmount();
                                        },
                                        deleteIconColor: Colors.white,
                                        backgroundColor: theme.accentColor,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color:
                                                  Colors.black), // Border color
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.h,
                                      ),
                                      const Spacer(),
                                      Text(
                                        "- ${ticketResponse?.company?.currency?.symbol ?? "\u20B9"} ${changePrice(discountPrice.value.toString())}",
                                        style: theme.labelStyle,
                                      )
                                    ],
                                  )
                          ],
                        ),
                        DecoratedBox(
                            decoration: BoxDecoration(
                                color: theme.secondaryBgColor?.withAlpha(80)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.v),
                              child: ValueListenableBuilder(
                                  valueListenable: totalPrice,
                                  builder: (context, value, child) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [],
                                    );
                                  }),
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.v),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total Payable",
                                      style: theme.labelStyle,
                                    ),
                                    Text(
                                      "${ticketResponse?.company?.currency?.symbol ?? "\u20B9"} ${totalPrice.value.toStringAsFixed(2)}",
                                      style: theme.labelStyle,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: CustomButton(
                                  
                                    onPressedCallback: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AnbocasPaymentWidget(
                                                    appliedCouponCode:
                                                        appliedCoupon,
                                                    eventResponse: ticketResponse!
                                                        .copyWithSelectedTickets(
                                                      tickets: selectedTickets,
                                                    ),
                                                    itemTotal: totalPrice.value,
                                                    totalFee: totalFee.value,
                                                    discountPrice:
                                                        discountPrice.value,
                                                    totalPrice:
                                                        totalPrice.value,
                                                  )),
                                        ),
                                    centerText: "Next"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          });
    }
  }

  Widget _buildTicketList(
      AnbocasEventResponse ticketsResp, AnbocasTicketBookingState state) {
    return ListView.builder(
      itemCount: ticketsResp.tickets.length,
      padding: EdgeInsets.symmetric(horizontal: 22.h),
      itemBuilder: (context, index) {
        var element = ticketsResp.tickets[index];
        return TicketItemWidget(
          isSelected: selectedTickets.contains(element),
          element: element,
          onBuyItemPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AnbocasSelectedTicketWidget(
                        ticketResponse: state.eventResponse.value!
                            .copyWithSelectedTickets(tickets: [element]),
                        eventId: widget.eventId,
                      )),
            );
          },
          onQuantityChanged: (newQuantity, ticketId) {
            setState(() {
              final index = selectedTickets
                  .indexWhere((SingleTicket ticket) => ticket.id == ticketId);

              if (index == -1) {
                final selectedTicket =
                    ticketsResp.tickets.firstWhere((t) => t.id == ticketId);
                selectedTickets.add(selectedTicket..selectedQuantity = 1);
              } else {
                if (newQuantity == 0) {
                  selectedTickets.removeAt(index);
                } else {
                  selectedTickets[index].selectedQuantity = newQuantity;
                }
              }
            });
            fetchCalculatedAmount();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        title: Text("Book your tickets", style: theme.headingStyle),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: _iconBack(theme.iconColor!),
        ),
      ),
      body: Builder(builder: (context) {
        final state = AnbocasTicketBookingWidget.of(context)!;
        return ValueListenableBuilder<bool>(
          valueListenable: state.isLoading,
          builder: (context, isLoading, child) {
            return isLoading
                ? _buildLoader()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.h),
                        child: ValueListenableBuilder<AnbocasEventResponse?>(
                            valueListenable: state.eventResponse,
                            builder: (context, ticketsResp, child) {
                              return state.eventResponse.value == null
                                  ? const SizedBox.shrink()
                                  : Text(
                                      state.eventResponse.value?.name ?? "",
                                      style: theme.headingStyle?.copyWith(
                                        color: theme.accentColor,
                                      ),
                                    );
                            }),
                      ),
                      SizedBox(
                        height: 15.v,
                      ),
                      ValueListenableBuilder<AnbocasEventResponse?>(
                          valueListenable: state.eventResponse,
                          builder: (context, ticketsResp, child) {
                            ticketResponse = ticketsResp;
                            return ticketsResp == null ||
                                    ticketsResp.tickets.isEmpty
                                ? Expanded(
                                    child: Center(
                                      child: Text(
                                        "No tickets found",
                                        style: theme.bodyStyle,
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                            child: _buildTicketList(
                                                ticketsResp, state)),
                                        _buildSummary()
                                      ],
                                    ),
                                  );
                          }),
                    ],
                  );
          },
        );
      }),
    );
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

abstract class AnbocasTicketBookingState
    extends State<AnbocasTicketBookingWidget> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final AnbocasBookingRepo? _booking = AnbocasServiceManager().bookingRepo;

  @override
  void didChangeDependencies() {
    _fetchEvent();
    super.didChangeDependencies();
  }

  ValueNotifier<AnbocasEventResponse?> eventResponse = ValueNotifier(null);
  List<SingleTicket> selectedTickets = [];

  Future<void> _fetchEvent() async {
    try {
      isLoading.value = true;
      await _booking
          ?.getEventById(
        eventId: widget.eventId,
      )
          .then((value) {
        eventResponse.value = value;
      });
      isLoading.value = false;
    } catch (e) {
      // if (e is DioException) {}
      isLoading.value = false;
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // if (_booking != null) _booking?.dispose();
    isLoading.dispose();
    eventResponse.dispose();
    super.dispose();
  }
}
