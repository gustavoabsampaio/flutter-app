import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'dart:core';

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
            ElevatedButton(
              onPressed: () => {
                Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/home'))
              },
              child: Text("Login"),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/home'))
              },
              child: Text("Skip"),
            ),
          ],
        )
      )
    );
  }
}