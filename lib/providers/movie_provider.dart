import 'package:enter_komputer_movies/service/api_service.dart';
import 'package:enter_komputer_movies/service/local_storage_service.dart';
import 'package:enter_komputer_movies/shared/models/movie_model.dart';
import 'package:flutter/material.dart';

/// Penyedia data film yang menggunakan [ChangeNotifier].
///
/// Kelas ini mengelola daftar film seperti film yang sedang tayang, film populer,
/// film dalam daftar tonton, dan film favorit. Kelas ini juga menyediakan metode
/// untuk memperbarui daftar tersebut dan memeriksa status film di daftar tonton
/// atau favorit.
class MovieProvider with ChangeNotifier {
  /// Layanan API untuk mengambil data film dari server.
  final ApiService apiService;

  /// Layanan penyimpanan lokal untuk menyimpan dan mengambil data film.
  final LocalStorageService localStorageService = LocalStorageService();

  /// Membuat instance dari [MovieProvider].
  ///
  /// [apiService] adalah layanan API yang digunakan untuk mengambil data film.
  MovieProvider(this.apiService);

  /// Daftar film yang sedang tayang saat ini.
  List<Movie> _nowPlayingMovies = [];

  /// Daftar film populer.
  List<Movie> _popularMovies = [];

  /// Daftar film dalam daftar tonton.
  List<Movie> _watchlistMovies = [];

  /// Daftar film favorit.
  List<Movie> _favoriteMovies = [];

  /// Mengembalikan daftar film yang sedang tayang saat ini.
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  /// Mengembalikan daftar film populer.
  List<Movie> get popularMovies => _popularMovies;

  /// Mengembalikan daftar film dalam daftar tonton.
  List<Movie> get watchlistMovies => _watchlistMovies;

  /// Mengembalikan daftar film favorit.
  List<Movie> get favoriteMovies => _favoriteMovies;

  /// Mengambil daftar film yang sedang tayang saat ini dari API.
  Future<void> fetchNowPlayingMovies() async {
    try {
      final response = await apiService.getNowPlayingMovies();
      _nowPlayingMovies = (response.data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching now playing movies: $e');
    }
  }

  /// Mengambil daftar film populer dari API.
  Future<void> fetchPopularMovies() async {
    try {
      final response = await apiService.getPopularMovies();
      _popularMovies = (response.data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching popular movies: $e');
    }
  }

  /// Mengambil daftar film dalam daftar tonton dari penyimpanan lokal.
  Future<void> fetchWatchlistMovies() async {
    try {
      final movieIds = await localStorageService.getWatchlist();
      _watchlistMovies = [];
      for (int id in movieIds) {
        final response = await apiService.getMovieDetails(id);
        _watchlistMovies.add(Movie.fromJson(response.data));
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching watchlist movies: $e');
    }
  }

  /// Mengambil daftar film favorit dari penyimpanan lokal.
  Future<void> fetchFavoriteMovies() async {
    try {
      final movieIds = await localStorageService.getFavorites();
      _favoriteMovies = [];
      for (int id in movieIds) {
        final response = await apiService.getMovieDetails(id);
        _favoriteMovies.add(Movie.fromJson(response.data));
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching favorite movies: $e');
    }
  }

  /// Menambahkan film ke dalam daftar tonton.
  ///
  /// [movie] adalah film yang akan ditambahkan ke dalam daftar tonton.
  void addMovieToWatchlist(Movie movie) {
    if (!watchlistMovies.contains(movie)) {
      watchlistMovies.add(movie);
      notifyListeners();
    }
  }

  /// Menghapus film dari daftar tonton.
  ///
  /// [movie] adalah film yang akan dihapus dari daftar tonton.
  void removeMovieFromWatchlist(Movie movie) {
    if (watchlistMovies.contains(movie)) {
      watchlistMovies.remove(movie);
      notifyListeners();
    }
  }

  /// Menambahkan film ke dalam daftar favorit.
  ///
  /// [movie] adalah film yang akan ditambahkan ke dalam daftar favorit.
  void addMovieToFavorites(Movie movie) {
    if (!favoriteMovies.contains(movie)) {
      favoriteMovies.add(movie);
      notifyListeners();
    }
  }

  /// Menghapus film dari daftar favorit.
  ///
  /// [movie] adalah film yang akan dihapus dari daftar favorit.
  void removeMovieFromFavorites(Movie movie) {
    if (favoriteMovies.contains(movie)) {
      favoriteMovies.remove(movie);
      notifyListeners();
    }
  }

  /// Memeriksa apakah film adalah film favorit.
  ///
  /// [movie] adalah film yang akan diperiksa.
  /// Mengembalikan `true` jika film ada dalam daftar favorit, `false` sebaliknya.
  bool isMovieFavorite(Movie movie) {
    return favoriteMovies.contains(movie);
  }

  /// Memeriksa apakah film ada dalam daftar tonton.
  ///
  /// [movie] adalah film yang akan diperiksa.
  /// Mengembalikan `true` jika film ada dalam daftar tonton, `false` sebaliknya.
  bool isMovieInWatchlist(Movie movie) {
    return watchlistMovies.contains(movie);
  }
}
