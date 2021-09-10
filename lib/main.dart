import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pgmp4u/Screens/MockTest/mockTest.dart';
import 'package:pgmp4u/Screens/MockTest/mockTestQuestions.dart';
import 'package:pgmp4u/Screens/PracticeTests/practiceTest.dart';
import 'package:pgmp4u/Screens/StartScreen/SplashScreen.dart';
import 'package:pgmp4u/Screens/StartScreen/startScreen.dart';
import 'package:pgmp4u/Screens/test.dart';

// import 'package:pgmp4u/Screens/test.dart';
import './Screens/Dashboard/dashboard.dart';
import './Screens/Auth/login.dart';

void main() async {
 
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (ctx) => SplashScreen(),
        '/start-screen': (ctx) => StartScreen(),
        '/login': (ctx) => LoginScreen(),
        '/test': (ctx) => Test(),
        '/dashboard': (ctx) => Dashboard(),
        '/practice-test': (ctx) => PracticeTest(),
        '/mock-test': (ctx) => MockTest(),
        '/mock-test-questions': (ctx) => MockTestQuestions()
      },
    );
  }
}
