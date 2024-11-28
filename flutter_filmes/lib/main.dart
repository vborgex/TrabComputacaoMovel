import 'package:flutter/material.dart';
import 'package:flutter_filmes/view/details_page.dart';
import 'package:flutter_filmes/view/home_page.dart';
import 'package:flutter_filmes/view/trending_movies_page.dart';

void main() {
  runApp(const MaterialApp(
    home: TrendingMoviesPage(),
    debugShowCheckedModeBanner: false,
  ));
}
