// import 'package:chat_app/Pages/home_page.dart';
import 'package:chat_app/Pages/profile_screen.dart';
// import 'package:chat_app/components/my_dialog.dart';
import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/components/my_dialog.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});
  final userCredential = FirebaseAuth.instance.currentUser;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: NeumorphicColors.background,
        body: Column(
          children: [
            GestureDetector(
              onTap: (){
                MyDialog.myConfirmationDialog(context,'Do you want to delete your AirChat account?', deleteAccount,
                            () => Navigator.of(context).pop());
              },//deleteAccount,
              child: Container(
                width: screenSize.width,
                height: screenSize.height * 0.15,
                child: Neumorphic(
                  margin: EdgeInsets.all(10),
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 7,
                    lightSource: LightSource.topLeft,
                    intensity: 0.75,
                    // color: Colors.grey
                  ),
                  // width: screenSize.width,
                  // height: screenSize.height * 0.1,
                  padding: const EdgeInsets.all(20.0),
                  // decoration: const BoxDecoration(
                  //   color: Color(0xFF333333),
                  //   borderRadius: BorderRadius.only(
                  //       topLeft: Radius.circular(15),
                  //       topRight: Radius.circular(15),
                  //       bottomLeft: Radius.circular(15),
                  //       bottomRight: Radius.circular(15)),
                  // ),
                  child: Center(
                    child: const Text(
                      'Delete account',
                      style: TextStyle(
                          color: NeumorphicColors.darkBackground, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: UpdateProfile,
              child: Container(
                width: screenSize.width,
                height: screenSize.height * 0.15,
                child: Neumorphic(
                  margin: EdgeInsets.all(10),
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 7,
                    lightSource: LightSource.topLeft,
                    intensity: 0.75,
                    // color: Colors.grey
                  ),
                  // width: screenSize.width,
                  // height: screenSize.height * 0.1,
                  padding: const EdgeInsets.all(20.0),
                  // decoration: const BoxDecoration(
                  //   color: Color(0xFF333333),
                  //   borderRadius: BorderRadius.only(
                  //       topLeft: Radius.circular(15),
                  //       topRight: Radius.circular(15),
                  //       bottomLeft: Radius.circular(15),
                  //       bottomRight: Radius.circular(15)),
                  // ),
                  child: Center(
                    child: const Text(
                      'Edit profile',
                      style: TextStyle(
                          color: NeumorphicColors.darkBackground, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: GestureDetector(
                    // onTap: () => MyDialog.myConfirmationDialog(
                    //     context, signOut, () => Navigator.of(context).pop()),
                    onTapDown: _onTapDown,
                    onTapUp: _onTapUp,
                    onTapCancel: () {
                      setState(() {
                        _isPressed = false;
                      });
                    },
                    child: NeumorphicButton(
                      onPressed: () {
                        MyDialog.myConfirmationDialog(context, 'Do you want to Logout?', signOut,
                            () => Navigator.of(context).pop());
                        _isPressed = !_isPressed;
                      },
                      child: Icon(Icons.logout,
                          color: NeumorphicColors.background),
                      // onPressed: ,//signOut,
                      style: NeumorphicStyle(
                        shape: NeumorphicShape
                            .convex, // You can use concave shape as well
                        boxShape: NeumorphicBoxShape.circle(),
                        color: NeumorphicColors.darkBackground,
                        depth: _isPressed
                            ? -8
                            : 4, // Adjust the depth for the neumorphic effect
                        intensity: _isPressed
                            ? 0.6
                            : 0.8, // Adjust intensity as needed
                      ), // Adjust intensity as needed
                    ),
                  ),
                ))
          ],
        ),
      );
    });
  }

  deleteAccount() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthGate(),
        ));
    final cuser = _auth.currentUser!.uid.toString();
    _firestore.collection('users').doc(cuser).delete();
    await _auth.currentUser!.delete();
  }

  UpdateProfile() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(), //ProfileScreen
        ));
    // final cuser = _auth.currentUser!.uid.toString();
    // _firestore.collection('users').doc(cuser).delete();
    // await _auth.currentUser!.delete();
  }

  void signOut() {
    Navigator.of(context).pop();
    final authServices = Provider.of<AuthServices>(context, listen: false);
    authServices.signOut();
  }
}
