import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Pages/chat_page.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_polygon_clipper/flutter_polygon_clipper.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserName,
      required this.receiverUserID});
  final String receiverUserEmail;
  final String receiverUserID;
  final String receiverUserName;

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  var currentUser = FirebaseAuth.instance.currentUser;
  String imageUrl = "";
  String name = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.receiverUserID)
          .get();

      if (documentSnapshot.exists) {
        // The document exists, you can access the field value using the field name.
        setState(() {
          name = documentSnapshot.get('name');
          imageUrl = documentSnapshot.get('imageURL');
          email = documentSnapshot.get('email');
        });
      } else {
        Center(child: Text('Loading ...'));
        // Document does not exist, handle the case if needed.
        // print('Document does not exist!');
      }
    } catch (error) {
      Center(child: Text('Error!'));
      // Handle the error if any.
      // print('Error fetching document: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.darkBackground,
      appBar: AppBar(
        // title: Text('Profile'),
        backgroundColor: NeumorphicColors.darkBackground,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.35,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: FlutterPolygonBorder(
                      sides: 5,
                      borderRadius: 10.0,
                    ),
                    side: BorderSide(
                      color: NeumorphicColors.background,
                      width: 2,
                    ),
                  ),
                  onPressed: () {},
                  child: FlutterClipPolygon(
                    sides: 5,
                    borderRadius: 10.0,
                    child: FullScreenWidget(
                      disposeLevel: DisposeLevel.High,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        //'https://static01.nyt.com/images/2023/05/28/multimedia/28CILLIAN-MURPHY-01-tzqm/28CILLIAN-MURPHY-01-tzqm-superJumbo.jpg',
                        fit: BoxFit
                            .cover, // Use BoxFit.contain to fit the image inside the pentagon without cropping
                        // ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                          color: Colors.redAccent,
                          strokeWidth: 2,
                        ),
                        errorWidget: (context, url, error) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * .2,
            // ),
            Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: NeumorphicColors.background,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  email, //"+91-9420853261",
                  style: TextStyle(
                      color: NeumorphicColors.background,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipOval(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.16,
                        height: MediaQuery.of(context).size.height * 0.08,
                        color: NeumorphicColors.background,
                        child: Icon(
                          Icons.call_sharp,
                          color: NeumorphicColors.darkBackground,
                        ),
                      ),
                    ),
                    ClipOval(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.16,
                        height: MediaQuery.of(context).size.height * 0.08,
                        color: NeumorphicColors.background,
                        child: Icon(
                          Icons.videocam_rounded,
                          color: NeumorphicColors.darkBackground,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: MyButton(
                onTap: () {
                  Navigator.of(context).pop();
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => ChatPage(
                  //         receiverUserEmail: widget.receiverUserEmail,
                  //         receiverUserName: widget.receiverUserName,
                  //         receiverUserID: widget.receiverUserID,
                  //       ),
                  //     ));
                },
                text: "Back to Home",
                color: NeumorphicColors.background,
                textColor: NeumorphicColors.darkBackground,
              ),
            )
          ],
        ),
      ),
    );
  }
}
