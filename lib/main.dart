import 'package:birthdayfafa/screens/Edhole.dart';
import 'package:birthdayfafa/screens/Memer.dart';
import 'package:birthdayfafa/screens/SpecialImage.dart';
import 'package:birthdayfafa/screens/SpecialInfo.dart';
import 'package:birthdayfafa/screens/VideoInfo.dart';
import 'package:birthdayfafa/screens/Videos.dart';
import 'package:birthdayfafa/screens/memes.dart';
import 'package:birthdayfafa/screens/selection_page.dart';
import 'package:birthdayfafa/screens/special.dart';
import 'package:flutter/material.dart';
import 'screens/signin.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignIn(),
      routes: {
        '/signin': (context) => SignIn(),
        '/select': (context) => SelectionPage(),
        '/Videos': (context) => Videos(),
        '/Memes': (context) => Memes(),
        '/Edho le': (context) => Edhole(),
        '/Special': (context) => Special(),
        '/SpecialInfo': (context)=> SpecialInfo(),
        '/SpecialImage': (context) => SpecialImage(),
        '/Memer': (context) => Memer(),
        '/VideoInfo': (context) => VideoInfo(),
      },
    );
  }
}


