import 'package:anbocas_tickets_api/anbocas_tickets_api.dart';
import 'package:anbocas_tickets_ui/src/anbocas_flutter_ticket_booking.dart';
import 'package:anbocas_tickets_ui/src/components/event_attedieess_count.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/screens/manage_attendies/scan_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCheckInListScreen extends StatefulWidget {
  final String eventId;
  const EventCheckInListScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<EventCheckInListScreen> createState() => _EventCheckInListScreenState();
}

class _EventCheckInListScreenState extends State<EventCheckInListScreen> {
  final _eventApi = AnbocasTicketsApi.event;
  final ValueNotifier<EventGuestsResponse?> _eventGuestsNotifier =
      ValueNotifier(null);
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _fetchCheckInAttendees();
  }

  Future<void> _fetchCheckInAttendees() async {
    try {
      final response =
          await _eventApi.guests(eventId: widget.eventId, paginate: false);
      _eventGuestsNotifier.value = response;
    } catch (e) {
      _isLoadingNotifier.value = false;
      debugPrint(e.toString());
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  void launchScanner() async {
    final response = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, __, ___) => ScanQrScreen(
          checkInOptions: CheckInOptions.ticket,
          eventId: widget.eventId,
        ),
      ),
    );

    if (response != null) {
      _fetchCheckInAttendees();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          backgroundColor: theme.backgroundColor,
          title: Text(
            "Manage Attendees",
            style: theme.headingStyle?.copyWith(fontWeight: FontWeight.w400),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: _iconBack(theme.iconColor!),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.qr_code,
                color: theme.primaryColor!,
              ),
              onPressed: () => launchScanner(),
            ),
          ],
        ),
        body: ValueListenableBuilder<bool>(
            valueListenable: _isLoadingNotifier,
            builder: (context, isLoading, child) {
              if (isLoading) {
                return Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 4.adaptSize,
                  color: theme.accentColor,
                  backgroundColor: Colors.white,
                ));
              }

              return ValueListenableBuilder<EventGuestsResponse?>(
                  valueListenable: _eventGuestsNotifier,
                  builder: (context, response, child) {
                    return (response == null)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Center(
                              child: Text(
                                "Unable to fetch Attendees",
                                style: theme.bodyStyle,
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              if (response.status != null)
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      22.h, 22.h, 30.h, 15.v),
                                  child: EventAttendeesCount(
                                      totalGuests:
                                          response.status!.all.toString(),
                                      totalCheckIn:
                                          response.status!.checkedIn.toString(),
                                      totalNotCheckIn: response
                                          .status!.notCheckedIn
                                          .toString()),
                                ),
                              response.data.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Center(
                                        child: Text(
                                          "No Attendees Check-In",
                                          style: theme.bodyStyle,
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              22.h, 0, 22.h, 15.v),
                                          child: ListView.separated(
                                            itemCount: response.data.length,
                                            itemBuilder: (context, index) {
                                              final guest =
                                                  response.data[index];
                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                trailing: Icon(
                                                  Icons.check_circle,
                                                  color:
                                                      guest.checkInTime != null
                                                          ? theme.primaryColor
                                                          : Colors.grey,
                                                ),
                                                leading: Text(
                                                  '${index + 1}.',
                                                  style: theme.labelStyle,
                                                ),
                                                title: Text(
                                                  guest.name ?? "",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      theme.bodyStyle?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16.fSize,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Text(
                                                    //   guest.orderTicket?.,
                                                    //   style:
                                                    //       theme.smallLabelStyle,
                                                    // ),
                                                    if (guest.checkInTime !=
                                                        null)
                                                      Text(
                                                        DateFormat()
                                                            .add_Hm()
                                                            .format(DateTime
                                                                .parse(guest
                                                                    .checkInTime!)),
                                                        style: theme
                                                            .smallLabelStyle
                                                            ?.copyWith(
                                                                color: theme
                                                                    .primaryColor),
                                                      ),
                                                  ],
                                                ),
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return Divider(
                                                color: theme.dividerColor,
                                              );
                                            },
                                          )),
                                    )
                            ],
                          );
                  });
            }));
  }

  // static void showScanPicker(BuildContext context, String eventId) {
  //   showModalBottomSheet(
  //       context: context,
  //       backgroundColor: theme.secondaryBgColor,
  //       builder: (context) {
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               title: Text("Scan Order", style: theme.bodyStyle),
  //               leading: const Icon(
  //                 Icons.arrow_forward,
  //                 color: Colors.white,
  //               ),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                   context,
  //                   PageRouteBuilder(
  //                     pageBuilder: (ctx, __, ___) => ScanQrScreen(
  //                       checkInOptions: CheckInOptions.order,
  //                       eventId: eventId,
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //             const Divider(),
  //             ListTile(
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                   context,
  //                   PageRouteBuilder(
  //                     pageBuilder: (ctx, __, ___) => ScanQrScreen(
  //                       checkInOptions: CheckInOptions.ticket,
  //                       eventId: eventId,
  //                     ),
  //                   ),
  //                 );
  //               },
  //               title: Text("Scan Ticket", style: theme.bodyStyle),
  //               leading: const Icon(
  //                 Icons.arrow_forward,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 30,
  //             )
  //           ],
  //         );
  //       });
  // }

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
