import 'package:flutter/material.dart';
import 'package:flutter_filmes/service/movie_service.dart';
import 'package:flutter_filmes/view/details_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrendingMoviesPage extends StatefulWidget {
  const TrendingMoviesPage({super.key});

  @override
  State<TrendingMoviesPage> createState() => _TrendingMoviesPageState();
}

class _TrendingMoviesPageState extends State<TrendingMoviesPage> {
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
              "Filmes populares",
              style: TextStyle(
                fontFamily: 'Ubuntu',
                color: Color.fromARGB(255, 13, 37, 63),
                fontSize: 30.0,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Expanded(
                child: FutureBuilder(
              future: trendingMovies(_page),
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
                      return Container();
                    } else {
                      return _createTrendingTable(context, snapshot);
                    }
                }
              },
            ))
          ]),
        ));
  }

  Widget _createTrendingTable(BuildContext context, AsyncSnapshot snapshot) {
    final movieData = snapshot.data;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0,  childAspectRatio: 0.7),
        itemCount: _getCount(movieData["results"]),
        itemBuilder: (context, index) {
          if (index < movieData["results"].length) {
            if (movieData["results"][index]["poster_path"] != null) {
              return GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0), // Bordas suavemente arredondadas
                child: Image.network(
                  "https://image.tmdb.org/t/p/original" +
                      movieData["results"][index]["poster_path"],
                      fit: BoxFit.cover,
                ),
              ),
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
              child: Column(
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
          return SizedBox.shrink();
        }
    );
  }

  int _getCount(List data) {
    return data.length + 1;
  }
}
