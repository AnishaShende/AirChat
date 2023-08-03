import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_text_field.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import '../services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserName,
      required this.receiverUserID});
  final String receiverUserEmail;
  final String receiverUserID;
  final String receiverUserName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool theme = false;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      _messageController.clear();
    } else {
      await _chatService.sendMessage(widget.receiverUserID, 'Hello!');
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          theme ? NeumorphicColors.darkBackground : NeumorphicColors.background,
      appBar: AppBar(
        title: Text(widget.receiverUserName),
        backgroundColor: const Color(0xFF333333),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                theme = !theme;
                setState(() {});
              },
              icon: Icon(
                Icons.favorite_rounded,
                color: theme ? Colors.redAccent : NeumorphicColors.background,
              ),
              color: NeumorphicColors.darkBackground,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error ${snapshot.error}',
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
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

          final messages = snapshot.data!.docs;
          final userId = _firebaseAuth.currentUser!.uid;

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final document = messages[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              // Mark the message as read if the receiver is the current user and the message is unread
              if (data['senderId'] != userId && data['read'].isEmpty) {
                _chatService.markMessageAsRead(
                    document.id, userId, widget.receiverUserID);
              }
              //     return ListView(
              //       children: snapshot.data!.docs
              //           .map((document) => _buildMessageItem(document))
              //           .toList(),
              //     );
              //   },
              // );
              // }

              // Widget _buildMessageItem(DocumentSnapshot document) {
              //   Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              // if (data['read'].isEmpty) {
              //   APIs.updateMessageReadStatus(widget.message);
              // }

              var alignment =
                  (data['senderId'] == _firebaseAuth.currentUser!.uid)
                      ? Alignment.centerRight
                      : Alignment.centerLeft;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  alignment: alignment,
                  child: Column(
                    crossAxisAlignment:
                        (data['senderId'] == _firebaseAuth.currentUser!.uid)
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    mainAxisAlignment:
                        (data['senderId'] == _firebaseAuth.currentUser!.uid)
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: [
                      // Text(data['senderEmail'],),
                      const SizedBox(
                        height: 5,
                      ),
                      // Text(data['message'],),
                      ChatBubble(
                        message: data['message'],
                        theme: theme,
                        isSender:
                            (data['senderId'] == _firebaseAuth.currentUser!.uid)
                                ? true
                                : false,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
  Widget _buildMessageInput() {

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
    child: Row(
      children: [
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.emoji_emotions_outlined),
          iconSize: 30,
          color: theme
              ? NeumorphicColors.background
              : NeumorphicColors.darkBackground,
        ),
        Expanded(
          child: MyTextField(
            controller: _messageController,
            hintText: 'Enter message',
            obscureText: false,
            extraFeatures: false,
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.photo),
          iconSize: 30,
          color: theme
              ? NeumorphicColors.background
              : NeumorphicColors.darkBackground,
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.camera_enhance_rounded),
          iconSize: 30,
          color: theme
              ? NeumorphicColors.background
              : NeumorphicColors.darkBackground,
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward),
            iconSize: 40,
            color: theme
                ? NeumorphicColors.background
                : NeumorphicColors.darkBackground,
          ),
        ),
      ],
    ),
  );
}
}
// Widget _buildMessageInput() {

//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
//     child: Row(
//       children: [
//         IconButton(
//           onPressed: sendMessage,
//           icon: const Icon(Icons.emoji_emotions_outlined),
//           iconSize: 30,
//           color: theme
//               ? NeumorphicColors.background
//               : NeumorphicColors.darkBackground,
//         ),
//         Expanded(
//           child: MyTextField(
//             controller: _messageController,
//             hintText: 'Enter message',
//             obscureText: false,
//             extraFeatures: false,
//           ),
//         ),
//         IconButton(
//           onPressed: sendMessage,
//           icon: const Icon(Icons.photo),
//           iconSize: 30,
//           color: theme
//               ? NeumorphicColors.background
//               : NeumorphicColors.darkBackground,
//         ),
//         IconButton(
//           onPressed: sendMessage,
//           icon: const Icon(Icons.camera_enhance_rounded),
//           iconSize: 30,
//           color: theme
//               ? NeumorphicColors.background
//               : NeumorphicColors.darkBackground,
//         ),
//         Padding(
//           padding: const EdgeInsets.all(6.0),
//           child: IconButton(
//             onPressed: sendMessage,
//             icon: const Icon(Icons.arrow_upward),
//             iconSize: 40,
//             color: theme
//                 ? NeumorphicColors.background
//                 : NeumorphicColors.darkBackground,
//           ),
//         ),
//       ],
//     ),
//   );
// }
// }
