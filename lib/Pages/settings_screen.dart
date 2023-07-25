import 'package:chat_app/Pages/home_page.dart';
import 'package:chat_app/Pages/profile_screen.dart';
import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});
  final userCredential = FirebaseAuth.instance.currentUser;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: NeumorphicColors.background,
        body: Column(
          children: [
            GestureDetector(
              onTap: deleteAccount,
              child: Container(
                width: screenSize.width,
                height: screenSize.height * 0.2,
                child: Neumorphic(
                  margin: EdgeInsets.all(10),
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)), 
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
                      style: TextStyle(color: NeumorphicColors.darkBackground, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: UpdateProfile,
              child: Container(
                width: screenSize.width,
                height: screenSize.height * 0.2,
                child: Neumorphic(
                  margin: EdgeInsets.all(10),
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)), 
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
                      style: TextStyle(color: NeumorphicColors.darkBackground, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),

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
}
