import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import 'package:intl/intl.dart';

import 'chat_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String formattedTime = '';
  bool isRead = false;
  late bool isCurrentUserSender = true;
  String lastMes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      backgroundColor: NeumorphicColors.background,
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: const Text(
            'Error!',
            style:
                TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: const Text(
            'Loading...',
            style: TextStyle(
                color: NeumorphicColors.darkBackground,
                fontWeight: FontWeight.bold),
          ));
        }

        return LiquidPullToRefresh(
          onRefresh: _handleRefresh,
          color: Colors.redAccent,
          height: 200,
          backgroundColor: Colors.deepPurple.shade200,
          animSpeedFactor: 2,
          showChildOpacityTransition: true,
          child: ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          ),
        );
      },
    );
  }

  // _chatRooms() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance.collection('chat_rooms').snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return Center(
  //             child: const Text(
  //           'Error!',
  //           style:
  //               TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
  //         ));
  //       }
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(
  //             child: const Text(
  //           'Loading...',
  //           style: TextStyle(
  //               color: NeumorphicColors.darkBackground,
  //               fontWeight: FontWeight.bold),
  //         ));
  //       }
  //       return Container();
  //       // lastMessageTime = snapshot.data.doc; //snapshot.data!.docs;
  //       // return LiquidPullToRefresh(
  //       //   onRefresh: _handleRefresh,
  //       //   color: Colors.redAccent,
  //       //   height: 200,
  //       //   backgroundColor: Colors.deepPurple.shade200,
  //       //   animSpeedFactor: 2,
  //       //   showChildOpacityTransition: true,
  //       //   child: ListView(
  //       //     children: snapshot.data!.docs
  //       //         .map<Widget>((doc) => _buildUserListItem(doc))
  //       //         .toList(),
  //       //   ),
  //       // );
  //     },
  //   );
  // }

  Future<DateTime?> getLastMessageTimestamp(String userEmail) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('chat_rooms')
        .where('users', arrayContains: userEmail)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> messageData = snapshot.docs[0].data();
      Timestamp timestamp = messageData['timestamp'];
      return timestamp.toDate();
    } else {
      return null;
    }
  }

  _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // DateTime? lastMessageTime;
    // String formattedTime = '';

    // if (data.containsKey('timestamp') && data['timestamp'] != null) {
    //   Timestamp timestamp = data['timestamp'];
    //   lastMessageTime = timestamp.toDate();
    //   formattedTime = DateFormat('hh:mm a').format(lastMessageTime);
    // } else {
    //   formattedTime = 'N/A';
    // }

    return StreamBuilder<QuerySnapshot>(
        stream: ChatService().getMessages(
          _auth.currentUser!.uid, // Current user's UID
          data['uid'], // Other user's UID from the 'users' collection
        ),
        builder: (context, snapshot) {
          // ... (Handle snapshot.hasData, loading, and errors)
          if (snapshot.hasError) {
            return Center(
                child: const Text(
              'Error!',
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            ));
          }
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(
          //       child: const Text(
          //     'Loading...',
          //     style: TextStyle(
          //         color: NeumorphicColors.darkBackground,
          //         fontWeight: FontWeight.bold),
          //   ));
          // }

          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
            if (messages.isNotEmpty) {
              // Get the last message's timestamp
              Timestamp lastMessageTimestamp = messages.last['timestamp'];
              DateTime lastMessageTime = lastMessageTimestamp.toDate();
              lastMes = messages.last['message'];

              // Now, you can use lastMessageTime to display the time of the last message
              formattedTime = DateFormat('hh:mm a').format(lastMessageTime);

              // Determine if the last message is read or not
              isRead = messages.last['read'].isEmpty ? false : true;

              isCurrentUserSender =
                  messages.last['senderId'] == _auth.currentUser!.uid;
              // Show the green dot or last message time based on isRead
              // if (isRead) {
              //   // Display the last message time
              //   return ListTile(
              //     // ... (Your existing list tile widgets)
              //     trailing: Text(
              //       formattedTime,
              //       style: TextStyle(color: NeumorphicColors.darkBackground),
              //     ),
              //   );
              // } else {
              //   // Display the green dot
              //   return ListTile(
              //     // ... (Your existing list tile widgets)
              //     trailing: Column(
              //       children: [
              //         Text(
              //           formattedTime,
              //           style: TextStyle(
              //               color: NeumorphicColors.darkBackground,
              //               fontSize: 10),
              //         ),
              //         Icon(Icons.circle_rounded, color: Colors.greenAccent),
              //       ],
              //     ),
              //   );
              // }
            }
          }

          // if (isRead) {
          //       // Display the last message time
          //       return ListTile(
          //         // ... (Your existing list tile widgets)
          //         trailing: Text(
          //           formattedTime,
          //           style: TextStyle(color: NeumorphicColors.darkBackground),
          //         ),
          //       );
          //     } else {
          //       // Display the green dot
          //       return ListTile(
          //         // ... (Your existing list tile widgets)
          //         trailing: Column(
          //           children: [
          // Text(
          //   formattedTime,
          //   style: TextStyle(
          //       color: NeumorphicColors.darkBackground,
          //       fontSize: 10),
          // ),
          //             Icon(Icons.circle_rounded, color: Colors.greenAccent),
          //           ],
          //         ),
          //       );
          //     }

          if (_auth.currentUser!.email != data['email']) {
            return Padding(
              padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.099,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 8, //customize depth here
                    lightSource: LightSource.topLeft,
                    // color: NeumorphicColors.background,
                    shape: NeumorphicShape.concave,
                    // color: Colors.grey,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    intensity: 0.89,
                    surfaceIntensity: 0.3,
                    //     border: NeumorphicBorder(
                    //   color: Color(0x33000000),
                    //   width: 0.8,
                    // ),
                  ),
                  // elevation: 0.5,
                  // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Center(
                    child: ListTile(
                      // tileColor: Color(0xFFEBEAEA),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      // leading: CircleAvatar(
                      //   child: Icon(Icons.person),
                      // ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: data['imageURL'],
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.height * 0.06,
                          fit: BoxFit.cover,
                          // 'assets/images/kim_taehyung_profile.jfif',
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Text(
                          data['name'],
                          style: TextStyle(
                              color: NeumorphicColors.darkBackground,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Text(
                          lastMes,
                          maxLines: 1,
                          style:
                              TextStyle(color: NeumorphicColors.darkBackground),
                        ),
                      ),
                      trailing: (isRead)
                          ? Text(
                              formattedTime,
                              style: TextStyle(
                                color: NeumorphicColors.darkBackground,
                              ),
                            )
                          : (isCurrentUserSender)
                              ? Container(
                                  margin: EdgeInsets.only(top: 3),
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(
                                        color: NeumorphicColors.darkBackground,
                                        fontSize: 13),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Text(
                                      formattedTime,
                                      style: TextStyle(
                                          color:
                                              NeumorphicColors.darkBackground,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Icon(Icons.circle_rounded,
                                        color: Colors.greenAccent),
                                  ],
                                ),
                      // ) :
                      // Text(
                      //   'N/A',
                      //   style:
                      //       TextStyle(color: NeumorphicColors.darkBackground),
                      // ),
                      // trailing: Container(
                      //   child: lastMessageTime != null
                      //       ? data['read'].isEmpty
                      //           ? Column(
                      //               children: [
                      //                 Text(
                      //                   formattedTime, //'11:11 AM',
                      //                   style: TextStyle(
                      //                       color: NeumorphicColors.darkBackground,
                      //                       fontSize: 10),
                      //                 ),
                      //                 Icon(Icons.circle_rounded,
                      //                     color: Colors.greenAccent),
                      //               ],
                      //             )
                      //           : Text(
                      //               formattedTime, //'11:11 AM',
                      //               style: TextStyle(
                      //                   color: NeumorphicColors.darkBackground),
                      //             )
                      //       : Text(
                      //           'N/A',
                      //           style:
                      //               TextStyle(color: NeumorphicColors.darkBackground),
                      //         ),
                      // ),

                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                receiverUserEmail: data['email'],
                                receiverUserName: data['name'],
                                receiverUserID: data['uid'],
                              ),
                            ));
                      },
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }
}
