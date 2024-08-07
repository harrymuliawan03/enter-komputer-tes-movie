import 'package:enter_komputer_movies/modules/detail_movie/presentation/detail_movie_content.dart';
import 'package:flutter/material.dart';

/// Layar detail film.
///
/// Kelas ini adalah widget stateless yang menampilkan konten detail film
/// menggunakan [DetailMovieContent] berdasarkan [movieId].
class DetailMovieScreen extends StatelessWidget {
  /// ID film yang akan ditampilkan detailnya.
  final int movieId;

  /// Membuat instance dari [DetailMovieScreen].
  ///
  /// [movieId] adalah ID dari film yang akan ditampilkan detailnya.
  const DetailMovieScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return DetailMovieContent(movieId: movieId);
  }
}
