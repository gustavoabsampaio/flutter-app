import 'package:flutter/material.dart';
import 'dart:core';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      home: LoginPage()
    );
  }
}

class UserEntries extends StatefulWidget {
  const UserEntries ({ Key? key }) : super(key: key);

  @override
  State<UserEntries> createState() => _UserEntriesState();
}

class _UserEntriesState extends State<UserEntries> {
  final List<String> _entryList = ["entry 1", "entry 2", "entry 3", "entry 4"];

  var _tapPosition;

  @override
  void initState() {
    super.initState();
    _tapPosition = Offset(0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _entryList.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTapDown: _storeTapPosition,
                onLongPress: () {
                  _showPopupMenu();
                },
                child: Card (
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(3.0, 15.0, 3.0, 15.0),
                        child: Text(_entryList[i]),
                        ),
                    ]                  
                  )
                )
              );
            }
          )
        )

      ]
    );
  }
  
  _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

    await showMenu(
      context: context, 
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40),
          Offset.zero & overlay.size
        ),
      items: [
        const PopupMenuItem(
          child: Text("Edit")
        ),
        const PopupMenuItem(
          child: Text("Delete")
        )
      ]
    );
  }

  void _storeTapPosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }
}