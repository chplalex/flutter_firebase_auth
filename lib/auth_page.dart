import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestState();
}

class _TestState extends State<AuthPage> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _facebookAuth = FacebookAuth.instance;

  OAuthCredential? credential;

  @override
  Widget build(BuildContext context) {
    final authWidget = _authWidget(context);
    final googleWidget = _googleWidget(context);
    final facebookWidget = _facebookWidget(context);
    final appleWidget = _appleWidget(context);
    final serverWidget = _serverWidget(context);
    final logoutWidget = _logoutWidget(context);

    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [authWidget, googleWidget, facebookWidget, appleWidget, serverWidget, logoutWidget],
      ),
    );
  }

  Widget _authWidget(BuildContext context) {
    final widget = StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        String text;
        if (snapshot.hasData) {
          final user = snapshot.data;
          text = "display name: ${user?.displayName}\n"
              "email: ${user?.email}\n"
              "uid: ${user?.uid}\n"
              "tenantId: ${user?.tenantId}\n"
              "refreshToken: ${user?.refreshToken}";
        } else {
          text = "no authenticated user";
        }
        return Padding(padding: const EdgeInsets.all(8.0), child: Text(text));
      },
    );

    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2.0),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        child: widget);
  }

  Widget _googleWidget(BuildContext context) {
    const text = Text("Google");
    final widget = MaterialButton(
      onPressed: _onGoogleAuth,
      child: text,
    );

    return widget;
  }

  Widget _facebookWidget(BuildContext context) {
    const text = Text("Facebook");
    final widget = MaterialButton(
      onPressed: _onFacebookAuth,
      child: text,
    );

    return widget;
  }

  Widget _appleWidget(BuildContext context) {
    const text = Text("Apple");
    final widget = MaterialButton(
      onPressed: _onAppleAuth,
      child: text,
    );

    return widget;
  }

  Widget _serverWidget(BuildContext context) {
    const text = Text("Push credential to server");
    final widget = MaterialButton(
      onPressed: () => {},
//      onPressed: _onServerPush,
      child: text,
    );

    return widget;
  }

  Widget _logoutWidget(BuildContext context) {
    const text = Text("logout");
    final widget = MaterialButton(
      onPressed: _onLogout,
      child: text,
    );

    return widget;
  }

  FutureOr<void> _onGoogleAuth() async {
    try {
      // *** Google side
      final googleSignInAccount = await _googleSignIn.signIn();
      final googleSignInAuthentication = await googleSignInAccount?.authentication;
      final accessToken = googleSignInAuthentication?.accessToken;
      final idToken = googleSignInAuthentication?.idToken;
      if (accessToken == null && idToken == null) {
        return;
      }
      credential = GoogleAuthProvider.credential(accessToken: accessToken, idToken: idToken);
      // *** Firebase side
      await _firebaseAuth.signInWithCredential(credential!);
    } catch (e, s) {
      log("Google authentication error => $e");
      log("Google authentication error stack =>\n$s");
    }
  }

  FutureOr<void> _onFacebookAuth() async {
    final LoginResult result = await _facebookAuth.login();
    log('Facebook auth result status => ${result.status}');

    if (result.status == LoginStatus.success) {
      log('result.accessToken => ${result.accessToken}');
    } else {
      log("result.message => ${result.message}");
      return;
    }

    credential = FacebookAuthProvider.credential(result.accessToken!.token);

    // *** Firebase side
    try {
      await _firebaseAuth.signInWithCredential(credential!);
    } catch (e, s) {
      log("Firebase authentication error => $e");
      log("Firebase authentication error stack =>\n$s");
    }

    log("wait 3 seconds");
    await Future.delayed(const Duration(seconds: 3));
    log("try auth again");

    try {
      await _firebaseAuth.signInWithCredential(credential!);
    } catch (e, s) {
      log("Firebase authentication error => $e");
      log("Firebase authentication error stack =>\n$s");
    }
  }

  void _onAppleAuth() {}

  FutureOr<void> _onLogout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await _facebookAuth.logOut();
  }
}
