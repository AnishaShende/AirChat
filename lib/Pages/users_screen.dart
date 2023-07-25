import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

import 'chat_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: const Text('Error!',  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const Text('Loading...', style: TextStyle(color: NeumorphicColors.darkBackground, fontWeight: FontWeight.bold),));
        }

        return LiquidPullToRefresh(
          onRefresh: _handleRefresh,
          color: Colors.deepPurple,
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

  _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Card(
          elevation: 0.5,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            // tileColor: Color(0xFFEBEAEA),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            // leading: CircleAvatar(
            //   child: Icon(Icons.person),
            // ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
              imageUrl: 'assets/images/kim_taehyung_profile.jfif',
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => CircleAvatar(
                child: Icon(Icons.person),
              ),
                    ),
            ),
            title: Text(data['name']),
            subtitle: Text(
              // 'Last user message',
              'last message',
              maxLines: 1,
            ),
            trailing: Text(
              '11:11 AM',
              style: TextStyle(color: NeumorphicColors.darkBackground),
            ),
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
      );
    } else {
      return Container();
    }
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }
}
