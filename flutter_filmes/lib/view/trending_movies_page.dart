import 'package:flutter/material.dart';
import 'package:flutter_filmes/service/movie_service.dart';
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            const Text(
              "Filmes populares",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
                child: FutureBuilder(
              future: trendingMovies(),
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
                      return _createTrendingTable(context, snapshot);
                    }
                }
              },
            ))
          ]),
        ));
  }

  Widget _createTrendingTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: _getCount(snapshot.data["results"]),
        itemBuilder: (context, index) {
          if (index < snapshot.data["results"].length) {
            if (snapshot.data["results"][index]["poster_path"] != null) {
              return GestureDetector(
                  child: Image.network(
                    "https://image.tmdb.org/t/p/original" +
                        snapshot.data["results"][index]["poster_path"],
                    height: 300.0,
                    fit: BoxFit.fitHeight,
                  ),
                  onTap: () {});
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
                        snapshot.data["results"][index]["title"],
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                        textAlign: TextAlign.center,
                      )
                    ]),
                onTap: () {
                  setState(() {});
                },
              );
            }
          } else if (_page != snapshot.data["total_pages"]) {
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
                  if (_page < snapshot.data["total_pages"]) {
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
