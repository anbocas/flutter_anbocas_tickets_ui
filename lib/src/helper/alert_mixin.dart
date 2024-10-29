import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/anbocas_flutter_ticket_booking.dart';
import 'package:flutter/material.dart';

mixin AlertDialogMixin {
  Future<void> showAlertDialog(
      BuildContext context, String title, String message,
      {String? okButtonText,
      void Function()? okPressed,
      bool hideIgnoreButton = false,
      Widget? topIcon}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          content: Text(message),
          icon: topIcon,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          backgroundColor: theme.secondaryBgColor,
          actions: [
            if (!hideIgnoreButton)
              TextButton(
                child: Text("Ignore",
                    style: TextStyle(
                      color: theme.primaryTextColor,
                      fontWeight: FontWeight.w700,
                    )),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            TextButton(
              child: Text(okButtonText ?? "Ok",
                  style: TextStyle(
                    color: theme.primaryTextColor,
                    fontWeight: FontWeight.w700,
                  )),
              onPressed: () {
                Navigator.pop(context);
                okPressed?.call();
              },
            ),
          ],
        );
      },
    );
  }
}
