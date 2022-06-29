import 'package:app/utils/google_sign_in.dart';
import 'package:app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/images/placeholder_logo.png')),
            ElevatedButton.icon(
              onPressed: () {
                final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              },
              icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
              label: Text("Sign in with Google"),
            ),
            ElevatedButton(
              onPressed: () async {
                final userCredential = await FirebaseAuth.instance.signInAnonymously();
                
                // Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/home'))
              },
              child: Text("Skip"),
            ),
          ],
        )
      )
    );
  }
}