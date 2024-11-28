import 'package:flutter/material.dart';
import 'package:flutter_filmes/service/movie_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailsPage extends StatefulWidget {
  final int id;
  DetailsPage({required this.id});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
  }

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
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: getMovieDetails(widget.id),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Container();
                      } else {
                        return _showMovieDetails(context, snapshot);
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _showMovieDetails(BuildContext context, AsyncSnapshot snapshot) {
  final movieData = snapshot.data;

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: movieData["poster_path"] != null
                  ? Image.network(
                      "https://image.tmdb.org/t/p/original${movieData["poster_path"]}",
                      height: 240.0,
                      width: 360.0,
                    )
                  : Container(
                      height: 240.0,
                      width: 360.0,
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          "Imagem não disponível",
                          style: TextStyle(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            movieData["title"] ?? "Título não disponível",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            "Título original: ${movieData["original_title"] ?? "Informação não disponível"}",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            "Data de lançamento: ${movieData["release_date"] ?? "Informação não disponível"}",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            "Sinopse:",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            movieData["overview"] ?? "Sinopse não disponível",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    ),
  );
}
