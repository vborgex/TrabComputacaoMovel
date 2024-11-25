import 'dart:convert';
import 'package:http/http.dart' as http;

String _key = 'b30ef7883b8c4934f2f2527d254c6c33';
String _accessToken =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMzBlZjc4ODNiOGM0OTM0ZjJmMjUyN2QyNTRjNmMzMyIsIm5iZiI6MTczMjU1NjI5Ny43MTcwNjU2LCJzdWIiOiI2NzNiOTMzYjVkNTRjZTdhNzRjODAyODAiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.GYv_6HHO39TE4q9hF2IxV1CGosvfZBwxAi6fF8fqzP8';

Future<Map<dynamic, dynamic>> searchMovies(String _search, int _page) async {
  http.Response response;

  response = await http.get(Uri.parse(
      "https://api.themoviedb.org/3/search/movie?api_key=$_key&query=$_search&include_adult=true&language=pt-BR&page=$_page"));
  print(response.body);
  return json.decode(response.body);
}

Future<Map<dynamic, dynamic>> trendingMovies() async {
  http.Response response;

  response = await http.get(Uri.parse(
      "https://api.themoviedb.org/3/trending/movie/day?api_key=$_key&language=pt-BR"));
  return json.decode(response.body);
}

Future<Map<dynamic, dynamic>> getMovieDetails(String _movieID) async {
  http.Response response;

  response = await http.get(Uri.parse(
      "https://api.themoviedb.org/3/movie/$_movieID?api_key=$_key&language=pt-BR&append_to_response=credits,similar"));
  return json.decode(response.body);
}
