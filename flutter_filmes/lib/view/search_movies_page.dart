import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../service/movie_service.dart'; // Certifique-se de que o caminho está correto
import 'details_page.dart'; // Importe a página de detalhes

class SearchMoviesPage extends StatefulWidget {
  const SearchMoviesPage({super.key});

  @override
  State<SearchMoviesPage> createState() => _SearchMoviesPageState();
}

class _SearchMoviesPageState extends State<SearchMoviesPage> {
  String _search = "";
  int _page = 1;

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
        padding: const EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          const Text(
            "Pesquise um filme",
            style: TextStyle(
              fontFamily: 'Ubuntu',
              color: Color.fromARGB(255, 13, 37, 63),
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            autofocus: true,
            cursorColor: const Color.fromARGB(255, 13, 37, 63),
            decoration: const InputDecoration(
              labelText: "Digite o nome do filme",
              labelStyle: TextStyle(fontFamily: 'Ubuntu', color: Color.fromARGB(255, 13, 37, 63)),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 13, 37, 63), width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 13, 37, 63), width: 2.0),
              ),
            ),
            style: const TextStyle(color: Color.fromARGB(255, 13, 37, 63), fontSize: 18),
            onSubmitted: (value) {
              setState(() {
                _search = value;
                _page = 1; // Reseta a página para a primeira
              });
            },
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: FutureBuilder(
              future: searchMovies(_search, _page),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center( // Use Center para centralizar o indicador
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 13, 37, 63)),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else {
                      return _createMovieTable(context, snapshot);
                    }
                }
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _createMovieTable(BuildContext context, AsyncSnapshot snapshot) {
    final movieData = snapshot.data;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.7
      ),
      itemCount: movieData["results"].length,
      itemBuilder: (context, index) {
        if (movieData["results"][index]["poster_path"] != null) {
          return GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500" + movieData["results"][index]["poster_path"],
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(id: movieData["results"][index]["id"]),
                ),
              );
            },
          );
        } else {
          return GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.no_photography_outlined,
                  color: Colors.black,
                  size: 70.0,
                ),
                Text(
                  movieData["results"][index]["title"],
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(id: movieData["results"][index]["id"]),
                ),
              );
            },
          );
        }
      },
    );
  }
}