import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proj2_real/splashScreen.dart';
import 'firebase_options.dart';
import 'widgets/navigationBar.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(home: SplashScreen()));
}
