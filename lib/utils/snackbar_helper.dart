import 'package:discount_deals/theme/theme.dart';
import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSnackBarWithAction(BuildContext context, String msg, String actionName,
    VoidCallback onPressed) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text('' + msg),
      action: SnackBarAction(
        label: actionName,
        onPressed: onPressed, // Custom onPressed function
      ),
    ),
  );
}

void showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      "" + msg,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
    ),
    elevation: 5,
    backgroundColor: MyColors.blackBG,
    action: SnackBarAction(
      label: "UNDO",
      textColor: MyColors.primaryColor,
      onPressed: () {}, // Custom onPressed function
    ),
  ));
}
