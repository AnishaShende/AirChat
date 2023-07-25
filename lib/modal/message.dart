import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderId,
      required this.senderEmail,
      required this.receiverId,
      required this.timestamp,
      required this.message});

  Map<String, dynamic> toMap() {
    return {
    'senderId' : senderId,
    'senderEmail' : senderEmail,
    'receiverId' : receiverId,
    'message' : message,
    'timestamp' : timestamp,
    };
  }
}

// class Message {
//   Message({
//     required this.toId,
//     required this.msg,
//     required this.read,
//     required this.type,
//     required this.fromId,
//     required this.sent,
//   });

//   late final String toId;
//   late final String msg;
//   late final String read;
//   late final String fromId;
//   late final String sent;
//   late final Type type;

//   Message.fromJson(Map<String, dynamic> json) {
//     toId = json['toId'].toString();
//     msg = json['msg'].toString();
//     read = json['read'].toString();
//     type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
//     fromId = json['fromId'].toString();
//     sent = json['sent'].toString();
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['toId'] = toId;
//     data['msg'] = msg;
//     data['read'] = read;
//     data['type'] = type.name;
//     data['fromId'] = fromId;
//     data['sent'] = sent;
//     return data;
//   }
// }

// enum Type { text, image }