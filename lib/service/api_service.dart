import 'package:dio/dio.dart';

/// Layanan untuk mengakses API The Movie Database (TMDB).
///
/// Kelas ini menggunakan [Dio] untuk melakukan permintaan HTTP ke endpoint
/// TMDB. Metode yang disediakan memungkinkan pengambilan film yang sedang tayang,
/// film populer, detail film, dan film serupa.
class ApiService {
  final Dio _dio;

  /// Membuat instance [ApiService].
  ///
  /// Inisialisasi [Dio] dengan konfigurasi dasar seperti [baseUrl] dan header [Authorization].
  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.themoviedb.org/3',
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2M2NiMmI5ODFhNmQ2YzJkYjg0MTAwNzMxOTQzNGQ4NCIsIm5iZiI6MTcyMjkzNjMzOC4wNjM0ODYsInN1YiI6IjY2YjFlYWY3NDhlZTU0MDY1OWExMzljNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.v_u6khDyNE31gXV7v5FpWKLcR_FAfxY6Q_M7ux2dbF0',
          },
        ));

  /// Mengambil daftar film yang sedang tayang di bioskop.
  ///
  /// Mengembalikan respons HTTP dari endpoint `/movie/now_playing`.
  Future<Response> getNowPlayingMovies() async {
    try {
      final response = await _dio.get('/movie/now_playing');
      return response;
    } catch (e) {
      print('Error fetching now playing movies: $e');
      rethrow;
    }
  }

  /// Mengambil daftar film populer.
  ///
  /// Mengembalikan respons HTTP dari endpoint `/movie/popular`.
  Future<Response> getPopularMovies() async {
    try {
      final response = await _dio.get('/movie/popular');
      return response;
    } catch (e) {
      print('Error fetching popular movies: $e');
      rethrow;
    }
  }

  /// Mengambil detail dari sebuah film berdasarkan [movieId].
  ///
  /// [movieId] adalah ID dari film yang ingin diambil detailnya.
  /// Mengembalikan respons HTTP dari endpoint `/movie/{movieId}`.
  Future<Response> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get('/movie/$movieId');
      return response;
    } catch (e) {
      print('Error fetching movie details for movieId $movieId: $e');
      rethrow;
    }
  }

  /// Mengambil daftar film yang serupa dengan sebuah film berdasarkan [movieId].
  ///
  /// [movieId] adalah ID dari film yang ingin diambil daftar film serupanya.
  /// Mengembalikan respons HTTP dari endpoint `/movie/{movieId}/similar`.
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
