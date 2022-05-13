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
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context) => const MyApp())
                  )
              },
              child: Text("Login"),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context) => const MyApp())
                  )
              },
              child: Text("Skip"),
            ),
          ],
        )
      )
    );
  }
}