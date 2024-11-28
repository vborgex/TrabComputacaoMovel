import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_filmes/service/movie_service.dart';
import 'package:flutter_filmes/view/details_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            TextField(
              autofocus: true,
              cursorColor: const Color.fromARGB(255, 13, 37, 63),
              decoration: const InputDecoration(
                labelText: "Digite o nome do filme",
                labelStyle: TextStyle(color: Color.fromARGB(255, 13, 37, 63)),
                border: OutlineInputBorder(), // Borda padrão
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 13, 37, 63),
                      width: 2.0), // Cor da borda quando habilitado
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 13, 37, 63),
                      width: 2.0), // Cor da borda quando em foco
                ),
              ),
              style: const TextStyle(
                  color: Color.fromARGB(255, 13, 37, 63), fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  _search = value;
                  _page = 1;
                });
              },
            ),
            Expanded(
                child: FutureBuilder(
              future: searchMovies(_search, _page),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createMovieTable(context, snapshot);
                    }
                }
              },
            ))
          ]),
        ));
  }

  Widget _createMovieTable(BuildContext context, AsyncSnapshot snapshot) {
    final movieData = snapshot.data;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: _getCount(movieData["results"]),
        itemBuilder: (context, index) {
          if (index < movieData["results"].length) {
            if (movieData["results"][index]["poster_path"] != null) {
              return GestureDetector(
                  child: Image.network(
                    "https://image.tmdb.org/t/p/original" +
                        movieData["results"][index]["poster_path"],
                    height: 300.0,
                    fit: BoxFit.fitHeight,
                  ),
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                  id: movieData["results"][index]["id"])));
                    });
                  });
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
                      )
                    ]),
                onTap: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsPage(
                                id: movieData["results"][index]["id"])));
                  });
                },
              );
            }
          } else if (_page != movieData["total_pages"]) {
            return GestureDetector(
              child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 70.0,
                    ),
                    Text(
                      "Carregar mais...",
                      style: TextStyle(color: Colors.black, fontSize: 22.0),
                    )
                  ]),
              onTap: () {
                setState(() {
                  if (_page < movieData["total_pages"]) {
                    _page += 1;
                  }
                });
              },
            );
          }
        });
  }

  int _getCount(List data) {
    return data.length + 1;
  }
}
