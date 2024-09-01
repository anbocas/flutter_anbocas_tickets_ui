// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/string_helper_mixin.dart';
import 'package:flutter/material.dart';

import 'package:anbocas_tickets_ui/src/model/single_company.dart';

class PriceBreakDownWidget extends StatelessWidget with StringHelperMixin {
  final double itemTotal;
  final double totalFee;
  final double totalPrice;
  final String? appliedCouponCode;
  final Currency currency;
  final double discountPrice;
  const PriceBreakDownWidget(
      {Key? key,
      required this.itemTotal,
      required this.totalFee,
      required this.totalPrice,
      this.appliedCouponCode,
      required this.currency,
      this.discountPrice = 0.00})
      : super(key: key);

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
                  padding: EdgeInsets.symmetric(vertical: 25.v),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 26, 25, 25),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30))),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sub Total",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.fSize,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "${currency.symbol ?? "\u20B9"} ${changePrice(itemTotal.toString())}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.fSize,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.v,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Convenience Fee",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.fSize,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "${currency.symbol ?? "\u20B9"} ${changePrice(totalFee.toStringAsFixed(2))}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.fSize,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.v,
                    ),
                    appliedCouponCode == null
                        ? const SizedBox()
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.h),
                            child: Row(
                              children: [
                                Text(
                                  "Coupon : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.fSize,
                                    color: Colors.grey,
                                  ),
                                ),
                                Chip(
                                  label: Text(appliedCouponCode.toString()),
                                  backgroundColor: Colors.orange,
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
                                  "- ${currency.symbol ?? "\u20B9"} ${changePrice(discountPrice.toString())}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.fSize,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                )
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    DecoratedBox(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(66, 137, 130, 130)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.h, vertical: 10.v),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Payable",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.fSize,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "${currency.symbol ?? "\u20B9"} ${changePrice(totalPrice.toString())}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.fSize,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              )
                            ],
                          ),
                        )),
                  ]))
            ])));
  }
}
