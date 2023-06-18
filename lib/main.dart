import 'package:flutter/material.dart';
import 'package:personal_chat_app/colors.dart';
import 'package:personal_chat_app/screens/welcone_screen.dart';

void main() {
  runApp(const MyApp());
}

// rgb(51,48,212)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: primary,
        ),
        home: WelcomeScreen());
  }
}
