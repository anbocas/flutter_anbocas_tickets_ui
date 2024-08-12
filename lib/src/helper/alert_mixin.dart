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
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Colors.white,
          actions: [
            if (!hideIgnoreButton)
              TextButton(
                child: const Text("Ignore",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    )),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            TextButton(
              child: Text(okButtonText ?? "Ok",
                  style: const TextStyle(
                    color: Colors.black,
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
