import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventAttendeesCount extends StatelessWidget {
  const EventAttendeesCount({
    super.key,
    required this.totalGuests,
    required this.totalCheckIn,
    required this.totalNotCheckIn,
  });

  final String totalGuests;
  final String totalCheckIn;
  final String totalNotCheckIn;

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
                border: Border.all(color: theme.secondaryTextColor!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ALL',
                    textAlign: TextAlign.center,
                    style: theme.bodyStyle,
                  ),
                  Text(
                    totalGuests,
                    style: theme.headingStyle,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: theme.secondaryTextColor!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CHECKED IN',
                    textAlign: TextAlign.center,
                    style: theme.bodyStyle,
                  ),
                  Text(
                    totalCheckIn,
                    style: theme.bodyStyle,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: theme.secondaryTextColor!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      'NOT CHECKED',
                      textAlign: TextAlign.center,
                      style: theme.bodyStyle,
                    ),
                  ),
                  Text(
                    totalNotCheckIn,
                    style: theme.bodyStyle,
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
