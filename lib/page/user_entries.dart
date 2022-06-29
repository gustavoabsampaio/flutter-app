import 'package:app/db/app_database.dart';
import 'package:app/model/entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:intl/intl.dart';

class UserEntries extends StatefulWidget {
  const UserEntries ({ Key? key }) : super(key: key);

  @override
  State<UserEntries> createState() => _UserEntriesState();
}

class _UserEntriesState extends State<UserEntries> {
  late List<Entry> entryList;
  bool isLoading = false;
  final quantidadeInputController = TextEditingController();

  var _tapPosition;
  DateTime _dateTime = DateTime.now();
  DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    refreshEntries();

    _tapPosition = const Offset(0.0, 0.0);

  }

  Future refreshEntries() async {
    setState(() {
      isLoading = true;
    });
    
    entryList = await AppDatabase.instance.readAllEntries();

    setState((() => isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: 
          [Column(
            children: isLoading? [const CircularProgressIndicator()]:  entryList.isEmpty
                                                             ? [const Text('Sem entradas')] :[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: entryList.length,
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTapDown: _storeTapPosition,
                      onLongPress: () {
                        _showPopupMenu(entryList[i].id);
                      },
                      child: Card (
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(3.0, 15.0, 3.0, 15.0),
                              child: Text('Quantidade: ' + entryList[i].quantidade.toString()+ '      Data: ' + formatter.format(entryList[i].data)),
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
                                    controller: quantidadeInputController,
                                    decoration: const InputDecoration(
                                      labelText: 'Quantidade',
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        formatter.format(_dateTime as DateTime),
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
                                            lastDate: DateTime.now()
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
                                  AppDatabase.instance.create(Entry(quantidade: int.parse(quantidadeInputController.text), data: _dateTime));
                                  quantidadeInputController.clear();
                                  _dateTime = DateTime.now();
                                  refreshEntries();
                                  Navigator.pop(context);
                                  
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

  _showPopupMenu(int? id) async {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

    await showMenu(
      context: context, 
      position: RelativeRect.fromRect(
          _tapPosition & const Size(40, 40),
          Offset.zero & overlay.size
        ),
      items: [
        // PopupMenuItem(
        //   child: Text("Edit"),
        //   // onTap: ,
        // ),
        PopupMenuItem(
          child: Text("Delete"),
          onTap: () {
            AppDatabase.instance.delete(id!);
            refreshEntries();
          },
        )
      ]
    );
  }

  void _storeTapPosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }
}
