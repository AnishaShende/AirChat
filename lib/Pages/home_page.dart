import 'package:chat_app/Pages/home_screen.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import 'package:provider/provider.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authServices = Provider.of<AuthServices>(context, listen: false);
    authServices.signOut();
  }

  int _currentIndex = 0; // Current selected index of the bottom navigation bar

  final List<Widget> _pages = [
    const HomeScreen(),
    const HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.darkBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color(0xFF333333),
        title: const Text("AirChat"),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: DotNavigationBar(
        backgroundColor: NeumorphicColors.darkBackground,
        selectedItemColor: NeumorphicColors.background,
        unselectedItemColor: Colors.grey,
        margin: EdgeInsets.all(5),
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            DotNavigationBarItem(icon: Icon(Icons.home)),
            DotNavigationBarItem(icon: Icon(Icons.history)),
            DotNavigationBarItem(
                icon: Icon(Icons.settings)),
          ]),
    );
  }

  // Widget _buildUserList() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance.collection('users').snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return const Text('Error!');
  //       }
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Text('Loading...');
  //       }

  //       return ListView(
  //         children: snapshot.data!.docs
  //             .map<Widget>((doc) => _buildUserListItem(doc))
  //             .toList(),
  //       );
  //     },
  //   );
  // }

  // _buildUserListItem(DocumentSnapshot document) {
  //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

  //   if (_auth.currentUser!.email != data['email']) {
  //     return ListTile(
  //       title: Text(data['email']),
  //       onTap: () {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => ChatPage(
  //                 receiverUserEmail: data['email'],
  //                 receiverUserName: data['name'],
  //                 receiverUserID: data['uid'],
  //               ),
  //             ));
  //       },
  //     );
  //   } else {
  //     return Container();
  //   }
  // }
}



