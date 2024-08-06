import 'package:enter_komputer_movies/providers/movie_provider.dart';
import 'package:enter_komputer_movies/screens/detail_movie/detail_movie_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileContent extends StatelessWidget {
  const UserProfileContent({super.key});
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Watchlist Movie'),
            FutureBuilder(
              future: movieProvider.fetchWatchlistMovies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: movieProvider.watchlistMovies.length,
                    itemBuilder: (context, index) {
                      final movie = movieProvider.watchlistMovies[index];
                      return ListTile(
                        title: Text(movie.title),
                        subtitle: Text(movie.overview),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailMovieScreen(movieId: movie.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
            const Text('Favorite Movie'),
            FutureBuilder(
              future: movieProvider.fetchFavoriteMovies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: movieProvider.favoriteMovies.length,
                    itemBuilder: (context, index) {
                      final movie = movieProvider.favoriteMovies[index];
                      return ListTile(
                        title: Text(movie.title),
                        subtitle: Text(movie.overview),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailMovieScreen(movieId: movie.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
