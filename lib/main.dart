import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'auth_page.dart';

void main() async {
  _setupLogging();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(AuthApp());
}

// ignore: must_be_immutable
class AuthApp extends StatelessWidget {
  AuthApp({Key? key}) : super(key: key);

  static const _exitTimeoutInMillis = 2500;

  DateTime _timePrevExitPressed = DateTime.now().subtract(const Duration(milliseconds: _exitTimeoutInMillis));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Demo App'),
        ),
        body: WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: const AuthPage(),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final timeLastExitPressed = DateTime.now();
    final diff = timeLastExitPressed.difference(_timePrevExitPressed);
    final canExit = diff.inMilliseconds <= _exitTimeoutInMillis;
    _timePrevExitPressed = timeLastExitPressed;

    log("diff = ${diff.inMilliseconds}, canExit = $canExit");

    if (canExit) return true;

    const snackBar = SnackBar(
      content: Text("Press back again to Exit"),
      duration: Duration(milliseconds: _exitTimeoutInMillis),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    log("Press back again to Exit");

    return false;
  }
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    log('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
