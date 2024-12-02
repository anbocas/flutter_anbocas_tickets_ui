// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anbocas_tickets_ui/src/screens/ticket_purchase/anbocas_order_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/snackbar_mixin.dart';
import 'package:anbocas_tickets_ui/src/model/api_response.dart';
import 'package:anbocas_tickets_ui/src/model/order_response.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_manager.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_repo.dart';

class AnbocasMyBookingScreen extends StatefulWidget {
  final String emailID;
  final String? referenceEventId;
  const AnbocasMyBookingScreen({
    Key? key,
    required this.emailID,
    this.referenceEventId,
  }) : super(key: key);

  @override
  State<AnbocasMyBookingScreen> createState() => _AnbocasMyBookingWidgetState();

  static AnbocasMyBookingWidgetState? of(BuildContext context) =>
      context.findAncestorStateOfType<AnbocasMyBookingWidgetState>();
}

class _AnbocasMyBookingWidgetState extends AnbocasMyBookingWidgetState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          backgroundColor: theme.backgroundColor,
          title: Text("My Bookings", style: theme.headingStyle),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: _iconBack(theme.iconColor!),
          ),
        ),
        body: Builder(builder: (context) {
          final state = AnbocasMyBookingScreen.of(context)!;
          return ValueListenableBuilder<bool>(
              valueListenable: state.isLoading,
              builder: (context, isLoading, child) {
                return isLoading
                    ? _buildLoader()
                    : state.orderList.value.isEmpty
                        ? Center(
                            child: Text(
                              "No Booking Found",
                              style: theme.labelStyle,
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 22.h),
                            itemCount: state.orderList.value.length,
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: theme.dividerColor,
                              );
                            },
                            itemBuilder: (context, index) {
                              var element = state.orderList.value[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AnbocasOrderDetailScreen(
                                      anbocasOrderId: element.id!,
                                    ),
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      element.event?.name ?? "",
                                      style: theme.subHeadingStyle,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        // (element.event?.imageUrl != null &&
                                        //         element.event!.imageUrl!
                                        //             .contains("http"))
                                        //     ? ClipRRect(
                                        //         borderRadius:
                                        //             BorderRadius.circular(15),
                                        //         child: DecoratedBox(
                                        //           decoration: BoxDecoration(
                                        //               color:
                                        //                   theme.secondaryBgColor),
                                        //           child: Image.network(
                                        //             element.event?.imageUrl ?? "",
                                        //             height: 90.v,
                                        //             width: 75.h,
                                        //             fit: BoxFit.fill,
                                        //           ),
                                        //         ),
                                        //       )
                                        //     : Container(
                                        //         height: 90.v,
                                        //         width: 75.h,
                                        //         decoration: BoxDecoration(
                                        //             color: theme.secondaryBgColor,
                                        //             borderRadius:
                                        //                 BorderRadius.circular(15)),
                                        //       ),
                                        // const SizedBox(
                                        //   width: 20,
                                        // ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${element.event?.startDate!}',
                                                  style: theme.smallLabelStyle),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Booking ID: ${element.orderNumber}",
                                                style: theme.smallLabelStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '₹${element.totalPayable.toStringAsFixed(2)}',
                                              style: theme.labelStyle?.copyWith(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              "${element.status}",
                                              style: theme.labelStyle?.copyWith(
                                                fontSize: 10.adaptSize,
                                                color: element.status ==
                                                        'COMPLETED'
                                                    ? Colors.green
                                                    : element.status ==
                                                            'PENDING'
                                                        ? Colors.yellow
                                                        : Colors.red,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
              });
        }));
  }

  Icon _iconBack(Color color) => Icon(
        Icons.arrow_back,
        color: color,
      );
  Widget _buildLoader() {
    return Center(
        child: CircularProgressIndicator(
      strokeWidth: 4.adaptSize,
      color: theme.accentColor,
      backgroundColor: Colors.white,
    ));
  }
}

abstract class AnbocasMyBookingWidgetState extends State<AnbocasMyBookingScreen>
    with SnackbarMixin {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final AnbocasBookingRepo? _booking = AnbocasServiceManager().bookingRepo;

  @override
  void didChangeDependencies() {
    _fetchInitialOrderLst();
    super.didChangeDependencies();
  }

  ValueNotifier<List<OrderData>> orderList = ValueNotifier([]);

  Future<void> _fetchInitialOrderLst() async {
    isLoading.value = true;
    ApiResponse<List<OrderData>>? response = await _booking?.getOrderByEmail(
      email: widget.emailID,
    );
    isLoading.value = false;
    if (response != null) {
      if (response.data != null) {
        orderList.value.addAll(response.data ?? []);
      }
      if (response.error != null) {
        if (!mounted) return;
        showAlertSnackBar(context, response.error ?? "Something went wrong");
      }
    }
  }

  @override
  void dispose() {
    isLoading.dispose();
    orderList.dispose();
    super.dispose();
  }
}
