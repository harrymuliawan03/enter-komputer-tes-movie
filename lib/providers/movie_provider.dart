import 'package:enter_komputer_movies/service/api_service.dart';
import 'package:enter_komputer_movies/service/local_storage_service.dart';
import 'package:enter_komputer_movies/shared/models/movie_model.dart';
import 'package:flutter/material.dart';

class MovieProvider with ChangeNotifier {
  final ApiService apiService;
  final LocalStorageService localStorageService = LocalStorageService();

  MovieProvider(this.apiService);

  List<Movie> _nowPlayingMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _watchlistMovies = [];
  List<Movie> _favoriteMovies = [];

  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get watchlistMovies => _watchlistMovies;
  List<Movie> get favoriteMovies => _favoriteMovies;

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

  Future<void> addMovieToWatchlist(Movie movie) async {
    await localStorageService.addMovieToWatchlist(movie.id);
    await fetchWatchlistMovies();
  }

  Future<void> removeMovieFromWatchlist(Movie movie) async {
    await localStorageService.removeMovieFromWatchlist(movie.id);
    await fetchWatchlistMovies();
  }

  Future<void> addMovieToFavorites(Movie movie) async {
    await localStorageService.addMovieToFavorites(movie.id);
    await fetchFavoriteMovies();
  }

  Future<void> removeMovieFromFavorites(Movie movie) async {
    await localStorageService.removeMovieFromFavorites(movie.id);
    await fetchFavoriteMovies();
  }
}
