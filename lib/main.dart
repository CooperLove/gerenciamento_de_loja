import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.pinkAccent[400],
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.pinkAccent[400],
              // selectedIconTheme: IconThemeData(color: Colors.white),
              selectedItemColor: Colors.white)),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void initializeFirebase() async {
  await Firebase.initializeApp();
}
