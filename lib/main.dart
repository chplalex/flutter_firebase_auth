import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/auth_page.dart';
import 'package:logging/logging.dart';

void main() async {
  _setupLogging();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(AuthApp());
}

class AuthApp extends StatelessWidget {
  AuthApp({Key? key}) : super(key: key);

  static const _exitCheckDuration = Duration(seconds: 2);

  DateTime _dtExitPressed = DateTime.now().subtract(_exitCheckDuration);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WillPopScope(
          onWillPop: () => _onWillPop(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Firebase Auth Demo Page'),
            ),
            body: const AuthPage(),
          ),
        ));
  }

  Future<bool> _onWillPop() async {
    final dt = DateTime.now();
    final diff = dt.difference(_dtExitPressed);
    return diff.inSeconds <= 2;
  }
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    log('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
