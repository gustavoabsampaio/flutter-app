import 'package:app/utils/google_sign_in.dart';
import 'package:app/page/login_page.dart';
import 'package:app/page/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'page/user_entries.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
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
        '/':(context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => const MyHomePage()
      }
    ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Something went wrong!'));
            }
            else if (snapshot.hasData) {
              return const MyHomePage();
            } else {
              return LoginPage();
            }
          }
      )
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image = File('');
  int _a = 0;
  int _navIndex = 0;

  final user = FirebaseAuth.instance.currentUser!;
  
  static const List<Widget> _widgetOptions = <Widget>[
    UserEntries(),
    Profile()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parando"),
        actions: [
          TextButton(
            onPressed: () async {
              print(user.isAnonymous);
              if(user.isAnonymous){
                await FirebaseAuth.instance.signOut();
                // Navigator.pushNamedAndRemoveUntil(context, '/login', ModalRoute.withName('/login'));
              }
              else {
                final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              }
            },
            child: user.isAnonymous? Text('Login'): Text('Logout')
          )
        ],
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

