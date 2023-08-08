import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/my_dialog.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble(
      {super.key,
      required this.message,
      required this.theme,
      required this.isSender,
      required this.type});
  final String message;
  final bool theme;
  final bool isSender;
  final String type;

  @override
  Widget build(BuildContext context) {
    if (type == 'Type.text') {
      return BubbleSpecialOne(
        text: message,
        tail: true,
        isSender: isSender,
        color: theme ? Colors.redAccent : Color(0XFF353535),
        textStyle: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else {
      return BubbleNormalImage(
        id: 'id0001',
        image: CachedNetworkImage(
          imageUrl: message,
          placeholder: (context, url) => CircularProgressIndicator(
            color: theme ? Color(0XFF353535) : Colors.redAccent,
            strokeWidth: 2,
          ),
          errorWidget: (context, url, error) => Padding(
            padding: const EdgeInsets.all(100.0),
            child: Icon(
              Icons.elderly_sharp,
              size: 50,
              color: Colors.redAccent,
            ),
          ),
        ),
        tail: true,
        isSender: isSender,
        color: theme ? Colors.redAccent : Color(0XFF353535),
      );
      // return Container();
    }
  }
}
