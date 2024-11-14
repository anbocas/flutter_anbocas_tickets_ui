import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventAttendeesCount extends StatelessWidget {
  const EventAttendeesCount({
    super.key,
    required this.totalGuests,
    required this.totalCheckIn,
    required this.totalSales,
  });

  final String totalGuests;
  final String totalCheckIn;
  final String totalSales;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72.v,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: theme.secondaryBgColor,
                borderRadius: BorderRadius.circular(8.adaptSize),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ALL',
                    textAlign: TextAlign.center,
                    style: theme.labelStyle,
                  ),
                  Text(
                    totalGuests,
                    style: theme.subHeadingStyle,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5.h,
          ),
          Flexible(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: theme.secondaryBgColor,
                borderRadius: BorderRadius.circular(8.adaptSize),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CHECKED',
                    textAlign: TextAlign.center,
                    style: theme.labelStyle,
                  ),
                  Text(
                    totalCheckIn,
                    style: theme.subHeadingStyle,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5.h,
          ),
          Flexible(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: theme.secondaryBgColor,
                borderRadius: BorderRadius.circular(8.adaptSize),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      'SALES',
                      textAlign: TextAlign.center,
                      style: theme.labelStyle,
                    ),
                  ),
                  Text(
                    '₹$totalSales',
                    style: theme.subHeadingStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
