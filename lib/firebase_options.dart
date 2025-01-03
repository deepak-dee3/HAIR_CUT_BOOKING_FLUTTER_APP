// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBX0GPWaLJ_zqs3ggLG9xiWHZfZmPptv-U',
    appId: '1:919899865815:web:6ffce11014070dd6fbe692',
    messagingSenderId: '919899865815',
    projectId: 'haircutapp1',
    authDomain: 'haircutapp1.firebaseapp.com',
    databaseURL: 'https://haircutapp1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'haircutapp1.firebasestorage.app',
    measurementId: 'G-FG0BEEJRL3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCHWTRhwtfCeFI1vU1dy0iPfcVwyzMAGGc',
    appId: '1:919899865815:android:5d619a2ed627b4e1fbe692',
    messagingSenderId: '919899865815',
    projectId: 'haircutapp1',
    databaseURL: 'https://haircutapp1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'haircutapp1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBF7zWZwsn2ygtJHRlg6E17leBp_vrMxvc',
    appId: '1:919899865815:ios:f5d90584096af90cfbe692',
    messagingSenderId: '919899865815',
    projectId: 'haircutapp1',
    databaseURL: 'https://haircutapp1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'haircutapp1.firebasestorage.app',
    iosBundleId: 'com.example.hair',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBF7zWZwsn2ygtJHRlg6E17leBp_vrMxvc',
    appId: '1:919899865815:ios:f5d90584096af90cfbe692',
    messagingSenderId: '919899865815',
    projectId: 'haircutapp1',
    databaseURL: 'https://haircutapp1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'haircutapp1.firebasestorage.app',
    iosBundleId: 'com.example.hair',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBX0GPWaLJ_zqs3ggLG9xiWHZfZmPptv-U',
    appId: '1:919899865815:web:c0c9d988d505f8cffbe692',
    messagingSenderId: '919899865815',
    projectId: 'haircutapp1',
    authDomain: 'haircutapp1.firebaseapp.com',
    databaseURL: 'https://haircutapp1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'haircutapp1.firebasestorage.app',
    measurementId: 'G-EVDRNG4T24',
  );
}
