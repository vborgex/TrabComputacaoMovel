import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_filmes/view/details_page.dart';
import 'package:flutter_filmes/view/search_movies_page.dart';
import 'package:flutter_filmes/view/trending_movies_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 37, 63),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/imgs/tmdb.svg',
              fit: BoxFit.contain,
              height: 20,
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0), // Espaço entre os quadrados
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0), // Bordas arredondadas
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      offset: Offset(0, 2), // Sombra
                    ),
                  ],
                ),
                height: 100, // Altura do quadrado
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.search_rounded, color: Color.fromARGB(255, 13, 37, 63), size: 40.0),
                    SizedBox(width: 10), // Espaço entre o ícone e o texto
                    Text(
                      "Pesquisar filme",
                      style: TextStyle(fontFamily: 'Ubuntu', color: Color.fromARGB(255, 13, 37, 63), fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchMoviesPage()));
              },
            ),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0), // Bordas arredondadas
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      offset: Offset(0, 2), // Sombra
                    ),
                  ],
                ),
                height: 100, // Altura do quadrado
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.trending_up_rounded, color: Color.fromARGB(255, 13, 37, 63), size: 40.0),
                    SizedBox(width: 10), // Espaço entre o ícone e o texto
                    Text(
                      "Filmes Populares",
                      style: TextStyle(fontFamily: 'Ubuntu', color: Color.fromARGB(255, 13, 37, 63), fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TrendingMoviesPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}