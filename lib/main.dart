import 'package:flutter/material.dart';
import 'package:pooclock/screens/bola_9_menu_screen.dart';
import 'package:pooclock/screens/game_selection_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Billar Pool Timer',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => GameSelectionScreen(),
        '/bola8': (context) =>
            Placeholder(), // Reemplaza con la pantalla correspondiente
        '/bola9': (context) => Bola9MenuScreen(),
        '/bola10': (context) => Placeholder(),
      },
    );
  }
}
