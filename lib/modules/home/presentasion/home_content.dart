import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enter_komputer_movies/providers/movie_provider.dart';
import 'package:enter_komputer_movies/screens/detail_movie/detail_movie_screen.dart';
import 'package:enter_komputer_movies/screens/user_profile/user_profile_screen.dart';
import 'package:enter_komputer_movies/shared/models/movie_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';

/// Layar beranda aplikasi Enter Komputer Movies.
///
/// Layar ini menampilkan daftar film yang sedang tayang dan film populer.
/// Pengguna dapat menambahkan film ke daftar tonton atau favorit, melihat
/// detail film, dan menyimpan gambar poster film ke penyimpanan lokal.
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    movieProvider.fetchNowPlayingMovies();
    movieProvider.fetchPopularMovies();
  }

  /// Menyimpan gambar dari [imageUrl] ke penyimpanan lokal.
  ///
  /// Memungkinkan pengguna memilih folder penyimpanan. Setelah folder
  /// dipilih, gambar diunduh dan disimpan dengan nama file berdasarkan
  /// waktu saat ini. Menampilkan snackbar untuk memberikan umpan balik kepada
  /// pengguna tentang hasil penyimpanan.
  Future<void> _saveImage(String imageUrl) async {
    try {
      // Memungkinkan pengguna memilih folder untuk menyimpan gambar
      final result = await FilePicker.platform.getDirectoryPath();

      if (result != null) {
        final filePath = '$result/${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Mengunduh data gambar
        final response = await _dio.get(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );

        // Menulis data gambar ke file
        final file = File(filePath);
        await file.writeAsBytes(response.data);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved to $result')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No directory selected.')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserProfileScreen()),
              );
            },
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Now Playing',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            ),
            Consumer<MovieProvider>(
              builder: (context, provider, child) {
                if (provider.nowPlayingMovies.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return SizedBox(
                    height: 330,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.nowPlayingMovies.length,
                      itemBuilder: (context, index) {
                        if (index >= 6) return Container();
                        final movie = provider.nowPlayingMovies[index];
                        return SizedBox(
                          width: 200,
                          child:
                              MovieCard(movie: movie, onSaveImage: _saveImage),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Popular',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            ),
            Consumer<MovieProvider>(
              builder: (context, provider, child) {
                if (provider.popularMovies.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return LimitedBox(
                    maxHeight: 600,
                    child: ListView.builder(
                      itemCount: provider.popularMovies.length,
                      itemBuilder: (context, index) {
                        if (index >= 20) return Container();
                        final movie = provider.popularMovies[index];
                        return MovieCard(movie: movie, onSaveImage: _saveImage);
                      },
                    ),
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

/// Kartu film untuk menampilkan detail film.
///
/// Kartu ini menampilkan poster film, judul, rating, dan beberapa
/// tombol aksi seperti menambahkan film ke daftar tonton atau favorit,
/// melihat detail film, dan menyimpan gambar poster film ke penyimpanan lokal.
class MovieCard extends StatelessWidget {
  /// Film yang akan ditampilkan di kartu.
  final Movie movie;

  /// Fungsi untuk menyimpan gambar dengan URL [imageUrl].
  final Future<void> Function(String) onSaveImage;

  const MovieCard({super.key, required this.movie, required this.onSaveImage});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    final isFavorite =
        movieProvider.favoriteMovies.any((m) => m.id == movie.id);
    final isWatchlist =
        movieProvider.watchlistMovies.any((m) => m.id == movie.id);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(8.0),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(15.0)),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.download, color: Colors.deepPurple),
                      onPressed: () {
                        final imageUrl =
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}';
                        onSaveImage(imageUrl);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Rating: ${movie.rating}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        isWatchlist
                            ? Icons.watch_later
                            : Icons.watch_later_outlined,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () {
                        if (isWatchlist) {
                          movieProvider.removeMovieFromWatchlist(movie);
                        } else {
                          movieProvider.addMovieToWatchlist(movie);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () {
                        if (isFavorite) {
                          movieProvider.removeMovieFromFavorites(movie);
                        } else {
                          movieProvider.addMovieToFavorites(movie);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.details, color: Colors.deepPurple),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailMovieScreen(movieId: movie.id),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
