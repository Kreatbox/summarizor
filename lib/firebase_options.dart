import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDUDeiWD2W6-j7HEkNX72_jQxHvZfx62gw',
    appId: '1:875974737683:web:5f9380d40c0f40be83e4e6',
    messagingSenderId: '875974737683',
    projectId: 'summarizor-1bc15',
    authDomain: 'summarizor-1bc15.firebaseapp.com',
    storageBucket: 'summarizor-1bc15.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDeFCTv17zh4MHctG8r8849SbnHc-Q5hvw',
    appId: '1:875974737683:android:6950f61a64e9600483e4e6',
    messagingSenderId: '875974737683',
    projectId: 'summarizor-1bc15',
    storageBucket: 'summarizor-1bc15.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjsTXZ2nCnkJJOptpaFHno_28-jJOgbqs',
    appId: '1:875974737683:ios:e4e95cd2edaaded283e4e6',
    messagingSenderId: '875974737683',
    projectId: 'summarizor-1bc15',
    storageBucket: 'summarizor-1bc15.firebasestorage.app',
    iosBundleId: 'com.kreators.summarizor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBjsTXZ2nCnkJJOptpaFHno_28-jJOgbqs',
    appId: '1:875974737683:ios:e4e95cd2edaaded283e4e6',
    messagingSenderId: '875974737683',
    projectId: 'summarizor-1bc15',
    storageBucket: 'summarizor-1bc15.firebasestorage.app',
    iosBundleId: 'com.kreators.summarizor',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDUDeiWD2W6-j7HEkNX72_jQxHvZfx62gw',
    appId: '1:875974737683:web:537b2affbe70db1083e4e6',
    messagingSenderId: '875974737683',
    projectId: 'summarizor-1bc15',
    authDomain: 'summarizor-1bc15.firebaseapp.com',
    storageBucket: 'summarizor-1bc15.firebasestorage.app',
  );
}
