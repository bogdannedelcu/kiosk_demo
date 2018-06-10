import 'package:flutter/material.dart';
import 'package:kiosk/mainpage.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(new MyApp());

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
  fontFamily: 'OpenSansCondensed',
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: kIOSTheme,
      title: 'Kiosk',
      home: new MainPage(title: 'Kiosk sales'),
    );
  }
}


