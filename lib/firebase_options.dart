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
    apiKey: 'AIzaSyBGs2-dxuGqijfzb2omV3UPPpO82EfICs8',
    appId: '1:985245789910:web:7bf22829b1591088ae6377',
    messagingSenderId: '985245789910',
    projectId: 'she-8267e',
    authDomain: 'she-8267e.firebaseapp.com',
    storageBucket: 'she-8267e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfA9pvcCr1tvJcoKXNBEU2V3lmCTmHjoo',
    appId: '1:985245789910:android:8dc627161e104b06ae6377',
    messagingSenderId: '985245789910',
    projectId: 'she-8267e',
    storageBucket: 'she-8267e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDqCZykUR8oVckfyAFBEe8agShlgf_E1xA',
    appId: '1:985245789910:ios:e2a1a864d26537f9ae6377',
    messagingSenderId: '985245789910',
    projectId: 'she-8267e',
    storageBucket: 'she-8267e.appspot.com',
    iosBundleId: 'com.example.sheSecure',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDqCZykUR8oVckfyAFBEe8agShlgf_E1xA',
    appId: '1:985245789910:ios:afa87b813fee3652ae6377',
    messagingSenderId: '985245789910',
    projectId: 'she-8267e',
    storageBucket: 'she-8267e.appspot.com',
    iosBundleId: 'com.example.sheSecure.RunnerTests',
  );
}
