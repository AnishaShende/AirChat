import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

Future<String?> getFirebaseMessagingToken() async {
  // NotificationSettings settings =
  String? token = '';
  await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await firebaseMessaging.getToken().then((t) => {
        if (t != null) {print('Push token: ' + t), token = t}
      });
  return token;
}

Future<void> sendPushNotification(
    String token, String userName, String message, String userID) async {
  try {
    final body = {
      "to": token,
      "notification": {
        "title": userName,
        "body": message,
        "android_channel_id": "chats",
      },
      "data": {
        "click_action": userID,
      }
    };

    // var url = Uri.https('example.com', 'whatsit/create');
    var response = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAAqVPLVKw:APA91bEjQNeiZcBxZ6kLEUDafQgS51UM56Kh6bJFWS8d-tPS0OFnEKjBtX68p3J3GZQOrR4CAvWFyM63WHMzAm14NW4CdxWRzNTzUR5ugzr--M-5B4CNlsCqn8rLNyDTu5yktgQO3AJZ'
        },
        body: jsonEncode(body));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  } catch (e) {
    print("Error sending push notification: $e");
  }
}
