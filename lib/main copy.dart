import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

final ImagePicker _picker = ImagePicker();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color.fromARGB(255, 189, 2, 2),
    fontFamily: 'Georgia',
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
      ),
      home: const MyHomePage(title: 'Titulo do app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image = File('');
  int _a = 0;
  
  Future getImage(ImageSource source) async{
    var image = await _picker.pickImage(source:source);
    
    if (image != null){
      setState(() {
        _image=File(image.path);
        _a++;
      });
    }
  }
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                showModalBottomSheet<void>(context: context, 
                builder: (BuildContext context) { 
                  return SafeArea( 
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[ 
                        ListTile( 
                          leading: const Icon(Icons.camera), 
                          title: const Text('Camera'), 
                          onTap: () {
                            getImage(ImageSource.camera);
                            Navigator.pop(context);
                          }, 
                        ),
                         ListTile(
                          leading: const Icon(Icons.image), 
                          title: const Text('Gallery'),
                          onTap: () {
                            getImage(ImageSource.gallery); 
                            Navigator.pop(context);
                          },
                        ),
                    ]
                  )
                );
              }
            ); 
              },
              child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 99, 4, 4), 
                      radius: 50.0,
                        child:ClipOval( 
                          child: _a==0
                          ?Image.asset('assets/images/default')
                          :Image.file(_image),
                      ))
                    
            ),
            Container(
              width: double.infinity,
              height: 350.0,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Text(
                      "Nome do Usuario",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                        "Você fumou: $_counter cigarros hoje"
                      ),
                    ]),
              )
                )]
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        
      ), 
      floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat, 
    );
  }
}