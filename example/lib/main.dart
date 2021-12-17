import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:catcher/catcher.dart';

void main() {
  CatcherError(
      runAppFunction: () {
        runApp(const MyApp());
      });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  void generateError() async {
    throw const FormatException("Test exception generated by Catcher");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: TextButton(onPressed: () => generateError(), child: const Text("Send Error")),
        ),
      ),
    );
  }
}