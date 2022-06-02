import 'package:app/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'user_entries.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final ImagePicker _picker = ImagePicker();

Future<FirebaseApp> loadFirebase() async {
  return await Firebase.initializeApp(
    name: "flutter_app",
    options: DefaultFirebaseOptions.currentPlatform
  );
}
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
        primaryColor: const Color.fromARGB(255, 189, 2, 2),
        fontFamily: 'Georgia',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/':(context) => Landing(),
        '/login': (context) => LoginPage(),
        '/home': (context) => const MyHomePage(title: "Parando")
      }
    );
  }
}

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  String _username = "";

  @override void initState() {
    super.initState();
    Future<FirebaseApp> _firebase = loadFirebase();
    _loadUserInfo();    
  }

  _loadUserInfo() async {
    // TODO get username
    if(_username == "") {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/home'));
      });
    }
    else {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/home'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
  int _navIndex = 0;
  
  static const List<Widget> _widgetOptions = <Widget>[
    UserEntries(),
    Profile()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _navIndex = index;
    });
  }

  Future getImage(ImageSource source) async{
    var image = await _picker.pickImage(source:source);
    
    if (image != null){
      setState(() {
        _image=File(image.path);
        _a++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(child: _widgetOptions.elementAt(_navIndex),),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Consumo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _navIndex,
        selectedItemColor: Colors.white,
        onTap: _onTabTapped
      ),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
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

  @override
  Widget build(BuildContext context) {
  return Center(
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
                          ?Image.asset('assets/images/default.png')
                          :Image.file(_image),
                      ))
                    
            ),
            SizedBox(
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
                      height: 50.0,
                    ),
                    const Text(
                      "Começou a fumar: xx/yy/zzzz",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Text(
                      "Fumou pela ultima vez: xx/yy/zzzz",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 3.0),
                      clipBehavior: Clip.antiAlias,
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0,vertical: 15.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: const <Widget>[
                                  Text(
                                    "Decidiu parar:",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    "dd/mm/yyyy",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: const <Widget>[
                                  Text(
                                    "Progresso:",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    "xx%",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: const [
                                  Text(
                                    "Dias sem fumar:",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    "n",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                   ),     
                )
              ]
              ),
            )
          )]
        ),
      );
  }
}