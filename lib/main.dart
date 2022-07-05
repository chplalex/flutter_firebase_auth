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

  static const _exitTimeoutInMillis = 2000;

  DateTime _dtPrevExitPressed = DateTime.now().subtract(const Duration(milliseconds: _exitTimeoutInMillis));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Firebase Auth Demo Page'),
            ),
            body: const AuthPage(),
          ),
        ));
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final dtNextExitPressed = DateTime.now();
    final diff = dtNextExitPressed.difference(_dtPrevExitPressed);
    final canExit = diff.inMilliseconds <= _exitTimeoutInMillis;
    print("diff = ${diff.inMilliseconds}, _onWiiPop() = $canExit");
      const snackBar = SnackBar(
        content: Text("Press back again to Exit"),
        duration: Duration(milliseconds: _exitTimeoutInMillis),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    _dtPrevExitPressed = dtNextExitPressed;
    return canExit;
  }
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    log('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
