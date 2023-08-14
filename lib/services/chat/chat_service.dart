import 'dart:developer';
import 'dart:io';

import 'package:chat_app/Pages/push_notifications.dart';
import 'package:chat_app/modal/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // late String chatRoomId;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    // String msg = Type.text ? message : 'image';
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
      read: '',
      send: time,
      type: Type.text,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap())
        .then((value) async {
      // Fetch user data from Firestore
      DocumentSnapshot senderSnapshot =
          await _firestore.collection('users').doc(currentUserId).get();

      if (senderSnapshot.exists) {
        String token = senderSnapshot['pushNotification'];
        String userName = senderSnapshot['name'];

        // Send push notification with token and username
        sendPushNotification(token, userName, message, currentUserId);
      }
    });
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots(); // Because of fucking 's' which I mistakenly added in timestamp, messages were not visible and my whole day was wasted to solve this fucking bug XXXXX WTFFF
  }

  Future<void> markMessageAsRead(
      String messageId, String userId, String otherUserId) async {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId) // Assuming messageId is the document ID of the message
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  Future<void> sendChatImage(String receiverId, File file) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    //getting image file extension
    final ext = file.path.split('.').last;

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    //storage file ref with path
    final ref = FirebaseStorage.instance.ref().child(
        'AirChat/ImageMessages/$chatRoomId/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    // await sendMessage(userId, imageUrl, Type.image);

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: imageUrl,
      read: '',
      send: time,
      type: Type.image,
    );

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap())
        .then((value) async {
      // Fetch user data from Firestore
      DocumentSnapshot senderSnapshot =
          await _firestore.collection('users').doc(currentUserId).get();

      if (senderSnapshot.exists) {
        String token = senderSnapshot['pushNotification'];
        String userName = senderSnapshot['name'];

        // Send push notification with token and username
        sendPushNotification(token, userName, 'image', currentUserId);
      }
    });
  }

  Future<void> deleteMessage(String messageId, String userId,
      String otherUserId, String type, String message) async {
    // final String currentUserId = _auth.currentUser!.uid;

    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .delete();

    if (type == "Type.image") {
      await FirebaseStorage.instance.refFromURL(message).delete();
    }
  }

  Future<void> updateMessage(String updatedmessage, String messageId,
      String userId, String otherUserId) async {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        // .doc(message.sent)
        .update({'message': updatedmessage});
  }
}
