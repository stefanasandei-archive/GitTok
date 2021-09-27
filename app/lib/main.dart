import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Git Tok',
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: Application(),
    );
  }
}

