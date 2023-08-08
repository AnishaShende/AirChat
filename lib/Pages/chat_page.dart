import 'dart:io';
import 'dart:developer';

import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/modal/message.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import '../services/chat/chat_service.dart';
import 'package:flutter/foundation.dart' as foundation;

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
  // bool _isAtBottom = true;
  bool _showEmoji = false;
  bool _isUploading = false;

  // @override
  // void initState() {
  //   super.initState();

  //   _scrollController.addListener(() {
  //     listenScrolling();
  //   });
  // }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  // void listenScrolling() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.minScrollExtent) {
  //     _isAtBottom = false;
  //   } else {
  //     _isAtBottom = true;
  //   }
  // }

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

  void sendImageMessage() async {
    // if (_messageController.text.isNotEmpty) {
    //   await _chatService.sendMessage(
    //       widget.receiverUserID, _messageController.text);
    //   _messageController.clear();
    // } else {
    //   await _chatService.sendMessage(widget.receiverUserID, 'Hello!');
    //   _messageController.clear();
    // }

    final ImagePicker picker = ImagePicker();

    // Picking multiple images
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 80);

    // uploading & sending image one by one
    for (var i in images) {
      log('Image Path: ${i.path}');
      setState(() => _isUploading = true);
      // await APIs.sendChatImage(widget.user, File(i.path));
      setState(() => _isUploading = false);

      await _chatService.sendChatImage(widget.receiverUserID, File(i.path));
      // await _chatService.sendChatImage(
      //     widget.receiverUserID, _messageController.text, Type.image);
      // sendChatImage
    }
  }

  void sendCameraMessage() async {
    // if (_messageController.text.isNotEmpty) {
    //   await _chatService.sendMessage(
    //       widget.receiverUserID, _messageController.text);
    //   _messageController.clear();
    // } else {
    //   await _chatService.sendMessage(widget.receiverUserID, 'Hello!');
    //   _messageController.clear();
    // }
    final ImagePicker picker = ImagePicker();

    // Pick an image
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (image != null) {
      log('Image Path: ${image.path}');
      setState(() => _isUploading = true);

      // await APIs.sendChatImage(widget.user, File(image.path));
      setState(() => _isUploading = false);
    }
    await _chatService.sendChatImage(widget.receiverUserID, File(image!.path));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          //if emojis are shown & back button is pressed then hide emojis
          //or else simple close current screen on back button click
          onWillPop: () {
            if (_showEmoji) {
              setState(() => _showEmoji = !_showEmoji);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            backgroundColor: theme
                ? NeumorphicColors.darkBackground
                : NeumorphicColors.background,
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
                      color: theme
                          ? Colors.redAccent
                          : NeumorphicColors.background,
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
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(strokeWidth: 2))),

                _buildMessageInput(),

                //show emojis on keyboard emoji button click & vice versa
                if (_showEmoji)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .35,
                    child: EmojiPicker(
                      textEditingController: _messageController,
                      config: Config(
                        bgColor: NeumorphicColors.darkBackground,
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isChatScreenOpenedForUser(String userId) {
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
              reverse: true,
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
                        child: DateChip(
                          date: currentDay!,
                          color: Colors.white,
                        ),
                        // Text(
                        //   _formatDateHeader(currentDay!),
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     // fontWeight: FontWeight.bold,
                        //     color: Colors.grey,
                        //   ),
                        // ),
                      ),
                      _buildMessageItem(data, userId),
                    ],
                  );
                } else {
                  // For messages of the same day, display them without the date header.
                  return _buildMessageItem(data, userId);
                }
              });
        });
  }

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
            const SizedBox(
              height: 5,
            ),
            // data['type'] == 'Type.text' ?
            ChatBubble(
              message: data['message'],
              theme: theme,
              isSender: (data['senderId'] == userId) ? true : false,
              type: data['type'],
            )
            // : ChatBubble(
            //   message: data['message'],
            //   theme: theme,
            //   isSender: (data['senderId'] == userId) ? true : false,
            //   type: data['type'],
            // ) ,
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
    } else {
      final formatter = DateFormat('d MMMM y');
      return formatter.format(dateTime);
    }
  }

  // void _scrollToBottom() {
  //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  //   // animateTo(
  //   //   _scrollController.position.maxScrollExtent,
  //   //   duration: Duration(milliseconds: 0),
  //   //   curve: Curves.easeOut,
  //   // );
  // }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              setState(() => _showEmoji = !_showEmoji);
            },
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
            onPressed: sendImageMessage,
            icon: const Icon(Icons.photo),
            iconSize: 30,
            color: theme
                ? NeumorphicColors.background
                : NeumorphicColors.darkBackground,
          ),
          IconButton(
            onPressed: sendCameraMessage,
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
                // if (_isAtBottom) {
                sendMessage();
                // } else {
                //   _scrollToBottom();
                // }
              },
              icon:
                  // _isAtBottom
                  //     ?
                  Icon(Icons.arrow_upward),
              // : Icon(Icons.arrow_downward),
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
