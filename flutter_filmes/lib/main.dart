import 'package:flutter/material.dart';
import 'package:flutter_filmes/view/details_page.dart';
import 'package:flutter_filmes/view/home_page.dart';
import 'package:flutter_filmes/view/trending_movies_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Montserrat',  // Defina a fonte padrão aqui
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}