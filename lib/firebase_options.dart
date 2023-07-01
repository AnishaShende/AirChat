// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDIiwTcVGq-ZDaTAEj9wFa-X8bvYUBcUwU',
    appId: '1:727255307436:web:f3721944efb829cba17b09',
    messagingSenderId: '727255307436',
    projectId: 'chatapp-19c69',
    authDomain: 'chatapp-19c69.firebaseapp.com',
    storageBucket: 'chatapp-19c69.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkt4FbSYNT-owBLhDHClLXXmrwnsxQ3lE',
    appId: '1:727255307436:android:709071d819414a42a17b09',
    messagingSenderId: '727255307436',
    projectId: 'chatapp-19c69',
    storageBucket: 'chatapp-19c69.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtu9N02U77dY59ieoJQYNdtnG_i-4rvqE',
    appId: '1:727255307436:ios:eb8861fe104f0245a17b09',
    messagingSenderId: '727255307436',
    projectId: 'chatapp-19c69',
    storageBucket: 'chatapp-19c69.appspot.com',
    androidClientId: '727255307436-vqs577qbhq9en4ssfitabneq1940lll4.apps.googleusercontent.com',
    iosClientId: '727255307436-1a4r9jm8o15a0fqvubj8i20g7e04583e.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtu9N02U77dY59ieoJQYNdtnG_i-4rvqE',
    appId: '1:727255307436:ios:bcef544ceae71affa17b09',
    messagingSenderId: '727255307436',
    projectId: 'chatapp-19c69',
    storageBucket: 'chatapp-19c69.appspot.com',
    androidClientId: '727255307436-vqs577qbhq9en4ssfitabneq1940lll4.apps.googleusercontent.com',
    iosClientId: '727255307436-b8cqmu9r3jh0ivdiqasjfu0e39bkvieb.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp.RunnerTests',
  );
}
