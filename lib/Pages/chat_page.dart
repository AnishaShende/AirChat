import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  late ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  bool theme = false;
  bool _isAtBottom = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      listenScrolling();
    });
    // _scrollController = ScrollController();

    // _scrollController.addListener(() {
    //   // Update _isAtBottom based on the scroll position

    //   // _isAtBottom = (_scrollController.position.pixels ==
    //   //     _scrollController.position.maxScrollExtent);

    // if (_scrollController.position.pixels ==
    //     _scrollController.position.maxScrollExtent) {
    //   _isAtBottom = !_isAtBottom;
    // } else {
    //   _isAtBottom = !_isAtBottom;
    // }
    // setState(() {}); // To trigger a rebuild and update the arrow icon
    // });

    // _messageFocusNode.addListener(() {
    //   if (_messageFocusNode.hasFocus) {
    //     _scrollToBottom();
    //   }
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void listenScrolling() {
    // setState(() {});
    if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      _isAtBottom = false;
      // setState(() {});
    } else {
      _isAtBottom = true;
      // setState(() {});
    }
    // setState(() {});
    // if (_scrollController.position.atEdge) {
    //   _scrollToBottom();
    //   //   _isAtBottom = false;
    //   // } else {
    //   // _isAtBottom = true;
    // }
  }

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

  bool _isChatScreenOpenedForUser(String userId) {
    // Add your logic here to determine if the chat screen is opened for this user
    // For example, you could compare the current user's ID with the provided userId
    // and return true if they are the same.
    return FirebaseAuth.instance.currentUser!.uid == userId;
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

          if (_isChatScreenOpenedForUser(
              FirebaseAuth.instance.currentUser!.uid)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
          }

          final messages = snapshot.data!.docs;
          final userId = _firebaseAuth.currentUser!.uid;

          DateTime? currentDay;

          return ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final document = messages[index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                if (data['senderId'] != userId && data['read'].isEmpty) {
                  _chatService.markMessageAsRead(
                      document.id, userId, widget.receiverUserID);
                }

                final timestamp = data['timestamp']
                    as Timestamp; // Assuming you have a field named 'timestamp' in your message data.

                // Format the timestamp into a DateTime object
                final messageDateTime = timestamp.toDate();
                final messageDate = messageDateTime.toLocal().toLocal();

                // Check if the current message belongs to a new day
                if (currentDay == null ||
                    currentDay!.year != messageDate.year ||
                    currentDay!.month != messageDate.month ||
                    currentDay!.day != messageDate.day) {
                  currentDay = messageDate;
                  // Display the date header before the first message of each new day
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          _formatDateHeader(currentDay!),
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      _buildMessageItem(data, userId),
                    ],
                  );
                } else {
                  // For messages of the same day, display them without the date header.
                  return _buildMessageItem(data, userId);
                }

                // Mark the message as read if the receiver is the current user and the message is unread
                // if (data['senderId'] != userId && data['read'].isEmpty) {
                //   _chatService.markMessageAsRead(
                //       document.id, userId, widget.receiverUserID);
                // }
                //     return ListView(
                //       children: snapshot.data!.docs
                //           .map((document) => _buildMessageItem(document))
                //           .toList(),
                //     );
                //   },
                // );
              });
        });
  }

  //             Widget _buildMessageItem(DocumentSnapshot document) {
  //               Map<String, dynamic> data = document.data() as Map<String, dynamic>;

  //             // if (data['read'].isEmpty) {
  //             //   APIs.updateMessageReadStatus(widget.message);
  //             // }

  //             var alignment =
  //                 (data['senderId'] == _firebaseAuth.currentUser!.uid)
  //                     ? Alignment.centerRight
  //                     : Alignment.centerLeft;
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 5.0),
  //               child: Container(
  //                 alignment: alignment,
  //                 child: Column(
  //                   crossAxisAlignment:
  //                       (data['senderId'] == _firebaseAuth.currentUser!.uid)
  //                           ? CrossAxisAlignment.end
  //                           : CrossAxisAlignment.start,
  //                   mainAxisAlignment:
  //                       (data['senderId'] == _firebaseAuth.currentUser!.uid)
  //                           ? MainAxisAlignment.end
  //                           : MainAxisAlignment.start,
  //                   children: [
  //                     // Text(data['senderEmail'],),
  //                     const SizedBox(
  //                       height: 5,
  //                     ),
  //                     // Text(data['message'],),
  //                     ChatBubble(
  //                       message: data['message'],
  //                       theme: theme,
  //                       isSender:
  //                           (data['senderId'] == _firebaseAuth.currentUser!.uid)
  //                               ? true
  //                               : false,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       });
  // }

  // Function to build the message item widget
  Widget _buildMessageItem(Map<String, dynamic> data, String userId) {
    var alignment = (data['senderId'] == userId)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: (data['senderId'] == userId)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == userId)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            // Text(data['senderEmail'],),
            const SizedBox(
              height: 5,
            ), // Text(data['message'],),
            ChatBubble(
              message: data['message'],
              theme: theme,
              isSender: (data['senderId'] == userId) ? true : false,
            ),
          ],
        ),
      ),
    );
  }

  // Function to format the date header
  String _formatDateHeader(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime); // 4 aug 3pm - 2 aug 9pm

    if (difference.inDays < 1) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else
    //  if (difference.inDays <= 2)
    {
      //   return 'Yesterday';
      // } else {
      //   // Format the date in your preferred way if the difference is more than 2 days.
      // return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      // Format the date using the intl package.
      final formatter = DateFormat('d MMMM y');
      return formatter.format(dateTime);
    }
  }

  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: Duration(milliseconds: 0),
    //   curve: Curves.easeOut,
    // );
    // _isAtBottom = true;
    // setState(() {
    // _isAtBottom = true;
    // });
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
              focusNode: _messageFocusNode,
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
              onPressed: () {
                // setState(() {});
                if (_isAtBottom) {
                  sendMessage();

                  // _scrollToBottom();
                } else {
                  _scrollToBottom();
                  // _isAtBottom = true;
                }
              },
              icon: _isAtBottom
                  ? Icon(Icons.arrow_upward)
                  : Icon(Icons.arrow_downward),
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
