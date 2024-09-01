import 'dart:async';
import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/components/anbocas_form_field.dart';
import 'package:anbocas_tickets_ui/src/components/custom_button.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/snackbar_mixin.dart';
import 'package:anbocas_tickets_ui/src/model/coupon_model.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_manager.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCouponWidget extends StatefulWidget {
  final String eventId;
  final double totalAmount;
  final void Function(String value, double discountPrice) validatedCoupon;
  const AddCouponWidget({
    Key? key,
    required this.eventId,
    required this.totalAmount,
    required this.validatedCoupon,
  }) : super(key: key);

  @override
  State<AddCouponWidget> createState() => _AddCouponWidgetState();
}

class _AddCouponWidgetState extends State<AddCouponWidget> with SnackbarMixin {
  final AnbocasBookingRepo? _booking = AnbocasServiceManager().bookingRepo;
  final TextEditingController voucherCtr = TextEditingController();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String?> errorText = ValueNotifier(null);
  Timer? _errorTimer;

  void validateCoupon(BuildContext context) async {
    isLoading.value = true;
    try {
      await _booking
          ?.validateCoupon(code: voucherCtr.text, eventId: widget.eventId)
          .then((value) {
        if (value != null) {
          if (value.couponType() == CouponTypeEnum.FIXED) {
            widget.validatedCoupon.call(voucherCtr.text, value.discount);
          } else if (value.couponType() == CouponTypeEnum.PERCENTAGE) {
            widget.validatedCoupon.call(
                voucherCtr.text, (widget.totalAmount * (value.discount / 100)));
          } else {
            errorText.value = "Invalid coupon type";
            _startErrorTimer();
          }
        } else {
          errorText.value = "Code is invalid";
          _startErrorTimer();
        }
      }).whenComplete(() => isLoading.value = false);
    } catch (e) {
      isLoading.value = false;
    }
  }

  void _startErrorTimer() {
    _errorTimer = Timer(const Duration(seconds: 4), () {
      errorText.value = null;
    });
  }

  @override
  void dispose() {
    if (_errorTimer != null) {
      _errorTimer?.cancel(); // Cancel the timer when the widget is disposed
    }
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: mediaQueryData.viewInsets,
      child: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: InkWell(
                child: Icon(
                  Icons.close,
                  size: 35.adaptSize,
                  color: theme.iconColor,
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
          SizedBox(
            height: 20.v,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 25.v),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 26, 25, 25),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              child: Column(
                children: [
                  Text(
                    "Enter a coupon code",
                    style:theme.headingStyle,
                  ),
                  SizedBox(
                    height: 40.v,
                  ),
                  Form(
                      key: _formKey,
                      child: AnbocasFormField(
                        formCtr: voucherCtr,
                        hintText: "Coupon code",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9]')),
                          UpperCaseTextFormatter(),
                        ],
                        inputAction: TextInputAction.done,
                        fieldValidator: (newValue) {
                          if (newValue == null || newValue.isEmpty) {
                            return "coupon is required";
                          }
                          return null;
                        },
                      )),
                  SizedBox(
                    height: 40.v,
                  ),
                  ValueListenableBuilder(
                      valueListenable: errorText,
                      builder: (context, text, child) {
                        return text == null
                            ? const SizedBox()
                            : Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0.v),
                                child: Text(
                                  text,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                      }),
                  ValueListenableBuilder(
                      valueListenable: isLoading,
                      builder: (context, loading, child) {
                        return loading == true
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : CustomButton(
                                centerText: "Apply Coupon",
                                onPressedCallback: () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  validateCoupon(context);
                                },
                              );
                      }),
                  SizedBox(
                    height: 20.v,
                  ),
                ],
              ))
        ],
      )),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Convert the text to uppercase
    final upperCaseText = newValue.text.toUpperCase();
    // Return the new text value
    return newValue.copyWith(
      text: upperCaseText,
      selection: TextSelection.collapsed(offset: upperCaseText.length),
    );
  }
}
