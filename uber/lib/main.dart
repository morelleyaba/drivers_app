// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uber/splashScreen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();

  runApp(
    MyApp(
      child: MaterialApp(
        title: 'Driver App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        // home: Scaffold(appBar: AppBar(title: Text("Welcome to Drivers App"))),
        // Rediriger notre home vers notre ecran d'acceuil 'splashScreen/splash_screen.dart' qui contient le logo 
        home: const MySplashScreen(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {

  final Widget? child;
  MyApp({this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child!,
    );
  }
}
