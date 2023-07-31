import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble(
      {super.key,
      required this.message,
      required this.theme,
      required this.isSender});
  final String message;
  final bool theme;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return BubbleSpecialOne(
      text: message,
      tail: true,
      isSender: isSender,
      color: theme ? Colors.redAccent : Color(0XFF353535),
      textStyle: TextStyle(
          fontSize: 16, color:Colors.white),
    );
  }
}
