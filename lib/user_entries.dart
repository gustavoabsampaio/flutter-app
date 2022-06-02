import 'package:flutter/material.dart';
import 'dart:core';
import 'package:intl/intl.dart';

class UserEntries extends StatefulWidget {
  const UserEntries ({ Key? key }) : super(key: key);

  @override
  State<UserEntries> createState() => _UserEntriesState();
}

class _UserEntriesState extends State<UserEntries> {
  final List<String> _entryList = ["entry 1", "entry 2", "entry 3", "entry 4"];

  var _tapPosition;
  DateTime _dateTime = DateTime.now();
  DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _tapPosition = const Offset(0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Column(
            children:[
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
              )]
          ),
          Container(
            padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height* 0.67, 0, 0),
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setStateForDialog) {
                        return AlertDialog(
                          scrollable: true,
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Quantidade',
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        formatter.format(_dateTime as DateTime)
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(80, 0, 0, 0)
                                      ),
                                      ElevatedButton(
                                        child: const Icon(Icons.calendar_month),
                                        onPressed: () {
                                          showDatePicker(
                                            context: context, 
                                            initialDate: _dateTime, 
                                            firstDate: DateTime(2021), 
                                            lastDate: DateTime(2121)
                                          ).then((date) {
                                            setStateForDialog(() {
                                              if(date != null){
                                                _dateTime = date;
                                              }
                                            });
                                          });
                                        },
                                      ),
                                    ]
                                  )
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                                child: const Text("Adicionar"),
                                onPressed: () {
                                  // adiciona entrada
                                })
                          ],
                        );
                      }
                    );
                  }
                );
              },
            )
          ),
          
        ],        
    );
  }
  
  _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

    await showMenu(
      context: context, 
      position: RelativeRect.fromRect(
          _tapPosition & const Size(40, 40),
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
