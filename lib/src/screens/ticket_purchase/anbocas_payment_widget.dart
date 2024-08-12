// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/logger_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/string_helper_mixin.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:anbocas_tickets_ui/src/screens/ticket_purchase/anbocas_booking_success_screen.dart';
import 'package:anbocas_tickets_ui/src/screens/ticket_purchase/anbocas_webview_payment.dart';
import 'package:anbocas_tickets_ui/src/components/anbocas_form_field.dart';
import 'package:anbocas_tickets_ui/src/components/custom_button.dart';
import 'package:anbocas_tickets_ui/src/components/price_break_down_widget.dart';
import 'package:anbocas_tickets_ui/src/helper/alert_mixin.dart';
import 'package:anbocas_tickets_ui/src/helper/snackbar_mixin.dart';
import 'package:anbocas_tickets_ui/src/model/order_response.dart';
import 'package:anbocas_tickets_ui/src/model/ticket_response.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_manager.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_repo.dart';

class AnbocasPaymentWidget extends StatefulWidget {
  final TicketResponse selectedTickets;
  final double itemTotal;
  final double totalFee;
  final double totalPrice;
  final String? appliedCouponCode;
  final double discountPrice;

  const AnbocasPaymentWidget({
    Key? key,
    required this.selectedTickets,
    required this.itemTotal,
    required this.totalFee,
    required this.totalPrice,
    this.appliedCouponCode,
    this.discountPrice = 0.0,
  }) : super(key: key);

  @override
  State<AnbocasPaymentWidget> createState() => _AnbocasPaymentWidgetState();
}

class _AnbocasPaymentWidgetState extends State<AnbocasPaymentWidget>
    with AlertDialogMixin, SnackbarMixin, StringHelperMixin, LoggerUtils {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  ValueNotifier<bool> loader = ValueNotifier(false);
  final AnbocasBookingRepo? _booking = AnbocasServiceManager().bookingRepo;
  late Razorpay razorpay;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    razorpay = Razorpay();
    info(userConfig.toString());
    if (userConfig.email != null) {
      email.text = userConfig.email ?? "";
    }
    if (userConfig.name != null) {
      name.text = userConfig.name ?? "";
    }
    if (userConfig.phone != null) {
      phone.text = userConfig.phone ?? "";
    }
    if (userConfig.countryCode != null) {
      _countryDialCode = userConfig.countryCode ?? "";
    }
    super.initState();
  }

  void placeAndGenerateOrder() async {
    try {
      loader.value = true;
      await _booking
          ?.placeOrder(
              coupon: widget.appliedCouponCode,
              selectedTickets: widget.selectedTickets.tickets,
              name: name.text,
              phone:
                  phone.text.isNotEmpty ? _countryDialCode! + phone.text : null,
              email: email.text)
          .then((order) {
        if (order != null) {
          handleNavigationAfterOrder(order);
        } else {
          showAlertSnackBar(
              context, "Something went wrong, Unable to generate order");
        }
      }).whenComplete(() => loader.value = false);
    } catch (e) {
      // log(e.toString());
      if (!mounted) return;
      showAlertSnackBar(context, e.toString());
      loader.value = false;
    }
  }

  void handleNavigationAfterOrder(OrderResponse order) {
    if (order.data != null) {
      lastOrderDetails = order;
      double totalPayable = order.data?.totalPayable ?? 0.00;
      if (totalPayable <= 0) {
        info("Navigating to Success screen while getting zeo total payable");
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AnbocasBookingSuccessScreen(
                    ticketResponse: widget.selectedTickets,
                    orderDetails: order.data!,
                  )),
        );
      } else {
        if (order.paymentUrl != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AnbocasWebviewPayment(
                        webUrl: order.paymentUrl ?? "",
                        orderDetails: order.data!,
                        selectedTickets: widget.selectedTickets,
                      )));
        } else {
          initiateRazorPay(order.data!);
        }
      }
    } else {
      showAlertSnackBar(
          context, "Something went wrong, Unable to generate order");
    }
  }

  OrderResponse? lastOrderDetails;

  void initiateRazorPay(OrderData order) {
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open({
      "key": "rzp_test_kB3PqQHXkqHye6",
      'amount': (order.totalPayable * 100),
      'currency': widget.selectedTickets.company?.currency?.code ?? "INR",
      'name': 'Anbocas Ticket',
      'description': 'Ticket Booking via Anbocas',
      'theme': {'color': '#000000'},
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': phone.text,
        'email': email.text,
      },
      'external': {
        'wallets': ['paytm']
      },
      'receipt': order.orderNumber,
      'notes': {
        'order_id': order.id,
        'event_id': order.eventId,
        'payer_name': name.text,
      }
    });
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(
      context,
      "Payment Failed",
      "${response.message}",
      hideIgnoreButton: true,
    );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => AnbocasBookingSuccessScreen(
                ticketResponse: widget.selectedTickets,
                orderDetails: lastOrderDetails!.data!,
              )),
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
      context,
      "External Wallet Selected",
      "${response.walletName}",
      hideIgnoreButton: true,
    );
  }

  String? _countryDialCode = '+91';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          backgroundColor: theme.backgroundColor,
          title: Text(
            "Checkout",
            style: theme.headingStyle?.copyWith(fontWeight: FontWeight.w400),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: _iconBack(theme.iconColor!),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0.h,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Text(
                        widget.selectedTickets.name ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.headingStyle?.copyWith(
                          color: theme.accentColor,
                        ),
                      ),
                      SizedBox(
                        height: 5.v,
                      ),
                      Text(
                        DateFormatter.formatDate(DateTime.parse(
                            widget.selectedTickets.startDate ?? "")),
                        style: theme.labelStyle,
                      ),
                      SizedBox(
                        height: 5.v,
                      ),
                      Text(
                        widget.selectedTickets.location ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.labelStyle,
                      ),
                      SizedBox(
                        height: 10.v,
                      ),
                      ...widget.selectedTickets.tickets
                          .map((e) => Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: theme.secondaryBgColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          e.name ?? "",
                                          style: theme.bodyStyle?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.h,
                                      ),
                                      Text(
                                        "x${e.selectedQuantity}",
                                        style: theme.bodyStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                      SizedBox(
                        height: 10.v,
                      ),
                      Text(
                        "Registration Details",
                        style: theme.bodyStyle?.copyWith(
                          color: theme.secondaryTextColor,
                        ),
                      ),
                      SizedBox(
                        height: 10.v,
                      ),
                      AnbocasFormField(
                        formCtr: name,
                        labelText: "Name",
                        hintText: "John doe",
                        fieldValidator: (newValue) {
                          if (newValue == null || newValue.isEmpty) {
                            return "name is required";
                          }
                          if (newValue.length < 5) {
                            return "full name should be long";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.v,
                      ),
                      AnbocasFormField(
                        formCtr: email,
                        labelText: "Email",
                        hintText: "your@gmail.com",
                        inputType: TextInputType.emailAddress,
                        fieldValidator: (newValue) {
                          if (newValue == null || newValue.isEmpty) {
                            return "email is required";
                          }
                          final emailRegExp =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegExp.hasMatch(newValue)) {
                            return "enter a validate email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.v,
                      ),
                      AnbocasFormField(
                        countryCode: _countryDialCode,
                        formCtr: phone,
                        labelText: "Phone",
                        hintText: "000-000-0000",
                        maxLength: 12,
                        showCountryPicker: true,
                        onCountryChanged: (v) {
                          _countryDialCode = v.dialCode;
                        },
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.phone,
                      ),
                      SizedBox(
                        height: 15.v,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0.v),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: theme.dividerColor),
                      SizedBox(
                        height: 5.v,
                      ),
                      Row(
                        children: [
                          Text.rich(
                            TextSpan(
                                text: "Total ",
                                style: theme.subHeadingStyle?.copyWith(
                                  color: Colors.white,
                                ),
                                children: [
                                  const TextSpan(text: "\n"),
                                  TextSpan(
                                    text:
                                        "${widget.selectedTickets.company?.currency?.symbol} ${changePrice(widget.itemTotal.toString())}",
                                    style: theme.subHeadingStyle,
                                  )
                                ]),
                            textAlign: TextAlign.left,
                          ),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return PriceBreakDownWidget(
                                        itemTotal: widget.itemTotal,
                                        totalFee: widget.totalFee,
                                        totalPrice: widget.totalPrice,
                                        appliedCouponCode:
                                            widget.appliedCouponCode,
                                        currency: widget
                                            .selectedTickets.company!.currency!,
                                        discountPrice: widget.discountPrice,
                                      );
                                    });
                              },
                              icon: Icon(
                                Icons.info,
                                color: theme.iconColor,
                              )),
                          SizedBox(
                            width: 10.h,
                          ),
                          Expanded(
                            child: ValueListenableBuilder(
                                valueListenable: loader,
                                builder: (context, loader, child) {
                                  return loader == true
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : CustomButton(
                                          centerText: "Pay Now",
                                          onPressedCallback: () {
                                            if (!_formKey.currentState!
                                                .validate()) {
                                              return;
                                            } else {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              placeAndGenerateOrder();
                                            }
                                          },
                                        );
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
