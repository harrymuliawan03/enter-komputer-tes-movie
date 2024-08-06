import 'package:dio/dio.dart';

class ApiService {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2M2NiMmI5ODFhNmQ2YzJkYjg0MTAwNzMxOTQzNGQ4NCIsIm5iZiI6MTcyMjkzNjMzOC4wNjM0ODYsInN1YiI6IjY2YjFlYWY3NDhlZTU0MDY1OWExMzljNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.v_u6khDyNE31gXV7v5FpWKLcR_FAfxY6Q_M7ux2dbF0';
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.themoviedb.org/3',
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2M2NiMmI5ODFhNmQ2YzJkYjg0MTAwNzMxOTQzNGQ4NCIsIm5iZiI6MTcyMjkzNjMzOC4wNjM0ODYsInN1YiI6IjY2YjFlYWY3NDhlZTU0MDY1OWExMzljNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.v_u6khDyNE31gXV7v5FpWKLcR_FAfxY6Q_M7ux2dbF0',
          },
        ));

  Future<Response> getNowPlayingMovies() async {
    try {
      final response = await _dio.get('/movie/now_playing');
      return response;
    } catch (e) {
      print('Error fetching now playing movies: $e');
      rethrow;
    }
  }

  Future<Response> getPopularMovies() async {
    try {
      final response = await _dio.get('/movie/popular');
      return response;
    } catch (e) {
      print('Error fetching popular movies: $e');
      rethrow;
    }
  }

  Future<Response> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get('/movie/$movieId');
      return response;
    } catch (e) {
      print('Error fetching movie details for movieId $movieId: $e');
      rethrow;
    }
  }

  Future<Response> getSimilarMovies(int movieId) async {
    try {
      final response = await _dio.get('/movie/$movieId/similar');
      return response;
    } catch (e) {
      print('Error fetching movie similar for movieId $movieId: $e');
      rethrow;
    }
  }
}
