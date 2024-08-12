import 'package:anbocas_tickets_ui/src/anbocas_flutter_ticket_booking.dart';
import 'package:anbocas_tickets_ui/src/screens/ticket_purchase/anbocas_selected_ticket_widget.dart';
import 'package:anbocas_tickets_ui/src/components/custom_button.dart';
import 'package:anbocas_tickets_ui/src/components/ticket_single_item.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/model/single_ticket.dart';
import 'package:anbocas_tickets_ui/src/model/ticket_response.dart';
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

class _AnbocasTicketBookingWidgetState extends AnbocasTicketBookingState {
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
      body: Builder(builder: (context) {
        final state = AnbocasTicketBookingWidget.of(context)!;
        return ValueListenableBuilder<bool>(
          valueListenable: state.isLoading,
          builder: (context, isLoading, child) {
            return isLoading
                ? Center(
                    child: CircularProgressIndicator.adaptive(
                    backgroundColor: theme.accentColor,
                  ))
                : Padding(
                    padding: EdgeInsets.fromLTRB(22.h, 0, 22.h, 15.v),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ValueListenableBuilder<TicketResponse?>(
                            valueListenable: state.tickets,
                            builder: (context, ticketsResp, child) {
                              return state.tickets.value == null
                                  ? const SizedBox()
                                  : Text(
                                      state.tickets.value?.name ?? "",
                                      style: theme.headingStyle?.copyWith(
                                        color: theme.accentColor,
                                      ),
                                    );
                            }),
                        SizedBox(
                          height: 15.v,
                        ),
                        ValueListenableBuilder<TicketResponse?>(
                            valueListenable: state.tickets,
                            builder: (context, ticketsResp, child) {
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
                                      child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: ticketsResp.tickets.length,
                                      padding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 10.v),
                                      itemBuilder: (context, index) {
                                        var element =
                                            ticketsResp.tickets[index];
                                        return TicketItemWidget(
                                          onItemSelect: () {
                                            setState(() {
                                              if (state.widget
                                                      .allowGroupTicket ==
                                                  false) {
                                                selectedTickets.clear();
                                                selectedTickets.add(element);
                                              } else {
                                                if (selectedTickets
                                                    .contains(element)) {
                                                  selectedTickets
                                                      .remove(element);
                                                } else {
                                                  selectedTickets.add(element);
                                                }
                                              }
                                            });
                                          },
                                          showBuyButton:
                                              !state.widget.allowGroupTicket,
                                          isSelected:
                                              selectedTickets.contains(element),
                                          element: element,
                                          onBuyItemPressed: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnbocasSelectedTicketWidget(
                                                        ticketResponse: state
                                                            .tickets.value!
                                                            .copyWithSelectedTickets(
                                                                tickets: [
                                                              element
                                                            ]),
                                                        eventId: widget.eventId,
                                                      )),
                                            );
                                          },
                                          onQuantityChanged: (v) {
                                            selectedTickets
                                                .asMap()
                                                .forEach((index, value) {
                                              if (value.id == element.id) {
                                                selectedTickets[index]
                                                    .selectedQuantity = v;
                                              }
                                            });
                                          },
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return Divider(
                                          color: theme.dividerColor,
                                        );
                                      },
                                    ));
                            }),
                        state.widget.allowGroupTicket == false
                            ? const SizedBox()
                            : CustomButton(
                                centerText: "Proceed",
                                onPressedCallback: () async {
                                  if (selectedTickets.isNotEmpty) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AnbocasSelectedTicketWidget(
                                                ticketResponse: state
                                                    .tickets.value!
                                                    .copyWithSelectedTickets(
                                                        tickets:
                                                            selectedTickets),
                                                eventId: widget.eventId,
                                              )),
                                    ).then((value) {
                                      selectedTickets.clear();
                                      setState(() {});
                                    });
                                  }
                                },
                              ),
                      ],
                    ),
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
    _fetchingBooking();
    super.didChangeDependencies();
  }

  ValueNotifier<TicketResponse?> tickets = ValueNotifier(null);
  List<SingleTickets> selectedTickets = [];

  Future<void> _fetchingBooking() async {
    try {
      isLoading.value = true;
      await _booking
          ?.getBookingTicket(
        eventId: widget.eventId,
      )
          .then((value) {
        tickets.value = value;
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
    tickets.dispose();
    super.dispose();
  }
}
