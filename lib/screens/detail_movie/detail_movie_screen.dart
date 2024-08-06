import 'package:enter_komputer_movies/modules/detail_movie/presentation/detail_movie_content.dart';
import 'package:flutter/material.dart';

class DetailMovieScreen extends StatelessWidget {
  final int movieId;
  const DetailMovieScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return DetailMovieContent(movieId: movieId);
  }
}
