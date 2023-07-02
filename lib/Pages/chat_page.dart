import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        title: Text(widget.receiverUserName),
        backgroundColor: const Color(0xFF333333),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(),),
          _buildMessageInput(),
          const SizedBox(height: 25,)
        ],
      ),
    );
  }


  Widget _buildMessageList() {
    return StreamBuilder(stream: _chatService.getMessages(widget.receiverUserID, _firebaseAuth.currentUser!.uid),
    builder: (context, snapshot) {
      if(snapshot.hasError){
        return Text('Error ${snapshot.error}');
      }
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Text('Loading...');
      }
      return ListView(
        children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
      );
    },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Text(data['senderEmail'],),
          const SizedBox(height: 5,),
          // Text(data['message'],),
          ChatBubble(message: data['message'],),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(child: MyTextField(controller: _messageController, hintText: 'Enter message', obscureText: false),),
          IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward), iconSize: 40,),
        ],
      ),
    );
  }
}
