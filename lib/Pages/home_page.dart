import 'package:chat_app/Pages/home_screen.dart';
import 'package:chat_app/services/auth/auth_servieces.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_screen.dart';

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
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEAEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        title: const Text("Home Page "),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
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



