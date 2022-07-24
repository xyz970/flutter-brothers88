import 'package:brothers88/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          
          color: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.black,
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
