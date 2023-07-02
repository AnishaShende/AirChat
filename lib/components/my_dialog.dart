import 'package:flutter/material.dart';

class MyDialog {
  static void mySnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.grey.shade800.withOpacity(0.8),
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void myProgressBar(BuildContext context) {
    showDialog(context: context, builder: (_) => Center(child: CircularProgressIndicator(color: Colors.grey.shade800,)));
  }
}
