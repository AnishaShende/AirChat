// import 'package:flutter/material.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class MyDialog {
  static void mySnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.grey.shade800.withOpacity(0.8),
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void myProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(
                child: CircularProgressIndicator(
              color: Colors.grey.shade800,
            )));
  }

  static void myConfirmationDialog(BuildContext context,
      VoidCallback onYesPressed, VoidCallback onNoPressed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // User can tap outside to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(
          //   'Do you want to Logout?',
          //   style: TextStyle(color: NeumorphicColors.darkBackground),
          // ),
          backgroundColor: Colors.transparent,
          content: Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
              depth: 4,
              intensity: 0.65,
              // lightSource: LightSource.topLeft,
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Do you want to Logout?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 16),
                  // Text('This is a Neumorphic-styled AlertDialog.'),
                  // SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NeumorphicButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          onYesPressed();
                        },
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(8.0)),
                          depth: 4,
                          intensity: 0.8,
                        ),
                        child: Text('Yes'),
                      ),
                      NeumorphicButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          onNoPressed();
                        },
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(8.0)),
                          depth: 4,
                          intensity: 0.8,
                        ),
                        child: Text('No'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // content: Text('Do you want to Logout?'),
          // actions: <Widget>[
          //   NeumorphicButton(
          //     onPressed: () {
          //       onYesPressed();
          //     },
          //     child: Text('Yes'),
          //   ),
          //   NeumorphicButton(
          //     onPressed: () {
          //       onNoPressed();
          //     },
          //     child: Text('No'),
          //   ),
          // ],
        );
      },
    );
  }
}
