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
    apiKey: 'AIzaSyAe2TlkEKTBoydPHC8EO-pspI92ne5Rc4E',
    appId: '1:313188262760:web:b6a8e8445f2019fa706cdd',
    messagingSenderId: '313188262760',
    projectId: 'mad-proj2',
    authDomain: 'mad-proj2.firebaseapp.com',
    storageBucket: 'mad-proj2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCG3fRF6fQk3ji8XuPPuZU0tqwQnaMNvGY',
    appId: '1:313188262760:android:84645995033156bf706cdd',
    messagingSenderId: '313188262760',
    projectId: 'mad-proj2',
    storageBucket: 'mad-proj2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyBZCc3-HZdof-tRrKZrFiSjfOXW06EhQ',
    appId: '1:313188262760:ios:7d7a94dd49fe5d08706cdd',
    messagingSenderId: '313188262760',
    projectId: 'mad-proj2',
    storageBucket: 'mad-proj2.appspot.com',
    iosBundleId: 'com.example.proj2Real',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDyBZCc3-HZdof-tRrKZrFiSjfOXW06EhQ',
    appId: '1:313188262760:ios:16e44327af0bc2c6706cdd',
    messagingSenderId: '313188262760',
    projectId: 'mad-proj2',
    storageBucket: 'mad-proj2.appspot.com',
    iosBundleId: 'com.example.proj2Real.RunnerTests',
  );
}
