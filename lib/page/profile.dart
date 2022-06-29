import 'package:app/db/app_database.dart';
import 'package:app/utils/google_sign_in.dart';
import 'package:app/page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_apps/device_apps.dart';

final ImagePicker _picker = ImagePicker();

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
  String _imagePath = 'assets/images/default.png';
  Image _image = Image.asset('assets/images/default.png');
  int _a = 0;
  bool isLoading = false;
  var installDate;
  final user = FirebaseAuth.instance.currentUser!;
  var newestEntry;
  var oldestEntry;
  var numDiasFumou;
  var numDiasSemFumarAtual;
  var numDiasSemFumarTotal;
  var porcentagemSemFumar;
  DateFormat formatter = DateFormat('dd/MM/yyyy');
  final percentageFormatter =  NumberFormat.decimalPattern(); // formatted number will be: 123.45


  @override
  void initState() {
    super.initState();

    refreshEntries();
  }

  Future refreshEntries() async {
    setState(() {
      isLoading = true;
    });
    

    newestEntry = await AppDatabase.instance.getNewest();
    oldestEntry = await AppDatabase.instance.getOldest();
    numDiasFumou = await AppDatabase.instance.numDiasFumou();
    numDiasSemFumarAtual = DateTime.now().difference(newestEntry.data).inDays;
    numDiasSemFumarTotal = await AppDatabase.instance.numDiasSemFumarTotal();
    
    print('-------------------data--------------------');
    print(newestEntry.data);
    print(oldestEntry.data);
    print(numDiasFumou);
    print(numDiasSemFumarAtual);
    print(numDiasSemFumarTotal);

    // porcentagemSemFumar = numDiasSemFumarTotal - numDiasFumou
    Application? app = await DeviceApps.getApp('com.example.app');

    installDate = DateTime.fromMillisecondsSinceEpoch(app!.installTimeMillis);

    porcentagemSemFumar = (DateTime.now().difference(installDate).inDays - numDiasFumou)/DateTime.now().difference(installDate).inDays*100;

    if (porcentagemSemFumar < 0) {
      porcentagemSemFumar = 0;
    }

    setState((() => isLoading = false));
  }

  Future getImage(ImageSource source) async{
    var image = await _picker.pickImage(source:source);
    
    if (image != null){
      setState(() {
        _imagePath = image.path;
        _image=Image.file(File(image.path));
        _a++;
      });
    }
  }


  bool hasImage() {
    if (_imagePath != 'assets/images/default.png'){
      return true;
    }
    return false;
  }

  Image loadImage() {
    if (hasImage()) {
      return _image;
    }
    else {
      if (user.isAnonymous == false) {
        _imagePath = user.photoURL!;
        return Image.network(_imagePath);
      }
      return Image.asset(_imagePath);
    }
  }

  String getUserName() {
    if(user.isAnonymous == false) {
      String name = user.displayName!;
      return name;
    }
    else {
      return "Usuario";
    }
  }

  @override
  Widget build(BuildContext context) {
  return Center(
        child: isLoading? const CircularProgressIndicator() : Column(
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
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipOval( 
                            child: loadImage()
                          )
                        )
                    )
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
                    Text(
                      getUserName(),
                      style: const TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Fumou pela ultima vez: " + formatter.format(newestEntry.data),
                      style: const TextStyle(
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
                                children: <Widget>[
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
                                    formatter.format(installDate),
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Dias sem fumar/fumou:",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    percentageFormatter.format(porcentagemSemFumar) + '%',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    "Dias sem fumar:",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    numDiasSemFumarAtual.toString(),
                                    style: const TextStyle(
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