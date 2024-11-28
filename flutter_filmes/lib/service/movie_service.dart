import 'dart:convert';
import 'package:http/http.dart' as http;

String _key = 'b30ef7883b8c4934f2f2527d254c6c33';

Future<Map<dynamic, dynamic>> searchMovies(String _search, int _page) async {
  http.Response response;

  response = await http.get(Uri.parse(
      "https://api.themoviedb.org/3/search/movie?api_key=$_key&query=$_search&include_adult=true&language=pt-BR&page=$_page"));
  return json.decode(response.body);
}

Future<Map<dynamic, dynamic>> trendingMovies(int _page) async {
  http.Response response;

  response = await http.get(Uri.parse(
      "https://api.themoviedb.org/3/trending/movie/day?api_key=$_key&language=pt-BR&page=$_page"));
  return json.decode(response.body);
}

Future<Map<dynamic, dynamic>> getMovieDetails(int _movieID) async {
  http.Response response;

  response = await http.get(Uri.parse(
      "https://api.themoviedb.org/3/movie/$_movieID?api_key=$_key&language=pt-BR"));
  return json.decode(response.body);
}
