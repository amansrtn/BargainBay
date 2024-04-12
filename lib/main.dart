import 'package:bhashini/Auth/splash_screen.dart';
import "package:flutter/material.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:kplayer/kplayer.dart';
import 'Auth/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Player.boot();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const splash_screen(),
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorSchemeSeed: Colors.greenAccent),
    );
  }
}
