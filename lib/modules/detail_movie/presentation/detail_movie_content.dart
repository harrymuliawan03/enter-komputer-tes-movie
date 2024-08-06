import 'package:enter_komputer_movies/service/api_service.dart';
import 'package:enter_komputer_movies/shared/models/movie_model.dart';
import 'package:flutter/material.dart';

class DetailMovieContent extends StatelessWidget {
  final int movieId;
  final ApiService apiService = ApiService();

  DetailMovieContent({super.key, required this.movieId});

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
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final movie = Movie.fromJson(snapshot.data!.data);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text(movie.title),
                  Text(movie.overview),
                  // Display other movie details here
                  const Text('Similar Movies'),
                  FutureBuilder(
                    future: apiService.getSimilarMovies(movieId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
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
                            return ListTile(
                              title: Text(movie.title),
                              subtitle: Text(movie.overview),
                            );
                          },
                        );
                      }
                    },
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
