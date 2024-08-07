import 'package:enter_komputer_movies/providers/movie_provider.dart';
import 'package:enter_komputer_movies/providers/user_provider.dart';
import 'package:enter_komputer_movies/screens/detail_movie/detail_movie_screen.dart';
import 'package:enter_komputer_movies/screens/login/login_screen.dart';
import 'package:enter_komputer_movies/shared/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Layar yang menampilkan profil pengguna.
///
/// Layar ini menampilkan nama pengguna yang sedang login, daftar film
/// yang ada di daftar tonton dan film favorit. Pengguna dapat menghapus
/// film dari daftar tonton atau daftar favorit serta melihat detail
/// film dengan mengetuk item film.
class UserProfileContent extends StatelessWidget {
  /// Membuat instance dari [UserProfileContent].
  const UserProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil nama pengguna dari [UserProvider].
    final userName = Provider.of<UserProvider>(context).userName;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, $userName',
          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Mengeluarkan pengguna dan mengarahkan ke layar login.
              Provider.of<UserProvider>(context, listen: false).logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Watchlist Movies',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildMovieList(
                  context,
                  movieProvider.watchlistMovies,
                  movieProvider,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Favorite Movies',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildMovieList(
                  context,
                  movieProvider.favoriteMovies,
                  movieProvider,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Membangun daftar film.
  ///
  /// Menerima [context], daftar [movies], dan instance [movieProvider].
  /// Menampilkan film dalam bentuk daftar. Jika daftar kosong, menampilkan
  /// pesan bahwa tidak ada film yang ditampilkan. Menyediakan opsi untuk
  /// menghapus film dari daftar tonton atau daftar favorit dan membuka
  /// detail film saat item diklik.
  ///
  /// [context] adalah konteks build.
  /// [movies] adalah daftar film yang akan ditampilkan.
  /// [movieProvider] adalah instance dari [MovieProvider].
  Widget _buildMovieList(
      BuildContext context, List<Movie> movies, MovieProvider movieProvider) {
    if (movies.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No movies to display.',
          style: TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        Movie movie = movies[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 4.0,
          child: ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                fit: BoxFit.cover,
                width: 50,
                height: 75,
              ),
            ),
            title: Text(
              movie.title,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              movie.overview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                if (movieProvider.watchlistMovies.contains(movie)) {
                  movieProvider.removeMovieFromWatchlist(movie);
                } else {
                  movieProvider.removeMovieFromFavorites(movie);
                }
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailMovieScreen(movieId: movie.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
