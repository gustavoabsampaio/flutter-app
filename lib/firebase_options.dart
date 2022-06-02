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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIIipJUud_fFXSefroFGmI__eB9FrBedU',
    appId: '1:761569662121:android:dc1ae783a0d5500e8205b8',
    messagingSenderId: '761569662121',
    projectId: 'flutter-app-6525c',
    storageBucket: 'flutter-app-6525c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAG9AzIpSZ3W3b0AJzsJH6C_afB83-z3wU',
    appId: '1:761569662121:ios:35cb434bb91573758205b8',
    messagingSenderId: '761569662121',
    projectId: 'flutter-app-6525c',
    storageBucket: 'flutter-app-6525c.appspot.com',
    androidClientId: '761569662121-c3smmcvva47motml09tom2a92vk8grrp.apps.googleusercontent.com',
    iosClientId: '761569662121-mnmi4lbf88cm8r6n0718um2hereorpma.apps.googleusercontent.com',
    iosBundleId: 'com.example.app',
  );
}
