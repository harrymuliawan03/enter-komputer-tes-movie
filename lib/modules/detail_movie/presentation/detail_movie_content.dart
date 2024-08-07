import 'package:flutter/material.dart';
import 'package:enter_komputer_movies/service/api_service.dart';
import 'package:enter_komputer_movies/shared/models/movie_model.dart';

/// Layar detail film yang menampilkan informasi lengkap tentang film.
///
/// Layar ini menampilkan gambar poster film, judul, deskripsi, tanggal rilis,
/// rating, dan daftar film serupa. Data film diambil dari API melalui
/// [ApiService].
class DetailMovieContent extends StatelessWidget {
  /// ID film yang akan ditampilkan di layar detail.
  final int movieId;

  /// Instansi [ApiService] untuk mengambil data film dari API.
  final ApiService apiService = ApiService();

  /// Konstruktor untuk [DetailMovieContent].
  ///
  /// [movieId] adalah ID film yang akan ditampilkan.
  DetailMovieContent({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Movie'),
      ),
      body: FutureBuilder(
        future: apiService.getMovieDetails(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final movie = Movie.fromJson(snapshot.data!.data);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Poster Film
                  Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul Film
                        Text(
                          movie.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16.0),
                        // Deskripsi Film
                        Text(
                          movie.overview,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16.0),
                        // Detail Lainnya Film
                        Row(
                          children: [
                            Text(
                              'Release Date: ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(movie.releaseDate.toString()),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Text(
                              'Rating: ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(movie.rating.toString()),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        // Bagian Film Serupa
                        const Text(
                          'Similar Movies',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        FutureBuilder(
                          future: apiService.getSimilarMovies(movieId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              final similarMovies =
                                  (snapshot.data!.data['results'] as List)
                                      .map((movie) => Movie.fromJson(movie))
                                      .toList();
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: similarMovies.length,
                                itemBuilder: (context, index) {
                                  Movie movie = similarMovies[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(8.0),
                                      leading: Image.network(
                                        'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                        fit: BoxFit.cover,
                                        width: 50,
                                      ),
                                      title: Text(movie.title),
                                      subtitle: Text(
                                        movie.overview,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
