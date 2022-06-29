import 'package:app/db/app_database.dart';
import 'package:app/model/entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:intl/intl.dart';
 
class Counter extends StatefulWidget {
  const Counter({ Key? key }) : super(key: key);
 
  @override
  State<Counter> createState() => _CounterState();
}
 
class _CounterState extends State<Counter> {
  Duration duration = Duration();
  Timer? timer;
 
  @override
  void initState() {
    super.initState();
 
    startTimer();
  }
 
  void addTimer(){
    final addSeconds = 1;
 
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
 
      duration = Duration(seconds: seconds);
    });
  }
 
  void reset(){
    setState(() => duration = Duration());
  }
 
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTimer());
  }
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(child: buildTime()),
    );
 
    Widget buildTime() {
      String twoDigits(int n) => n.toString().padLeft(2,'0');
      final days = twoDigits(duration.inDays);
      final hours = twoDigits(duration.inHours.remainder(24));
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Text(
          "Tempo Sem fumar:"
        ),
        SizedBox(
          height: 20,
        ),
        Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        buildTimeCard(time: days, header: 'Dias'),
        const SizedBox(width: 8),
        buildTimeCard(time: hours, header: 'Horas'),
        const SizedBox(width: 8),
        buildTimeCard(time: minutes, header: 'Minutos'),
        ]
      ),
      SizedBox(height: 40),
      TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: () => reset(),
          child: Text('Fumei',
          style: TextStyle(color: Colors.black,fontSize:24)),
        )
      ]
      );
    }
 
    Widget buildTimeCard(
      {required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
              ),
          child:Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 72,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(header),
          ]
       );
}
