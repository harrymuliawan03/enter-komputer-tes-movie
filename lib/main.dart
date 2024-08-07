import 'package:enter_komputer_movies/modules/detail_movie/presentation/detail_movie_content.dart';
import 'package:enter_komputer_movies/modules/user_profile/presentasion/user_profile_content.dart';
import 'package:enter_komputer_movies/providers/movie_provider.dart';
import 'package:enter_komputer_movies/providers/user_provider.dart';
import 'package:enter_komputer_movies/screens/home/home_screen.dart';
import 'package:enter_komputer_movies/screens/login/login_screen.dart';
import 'package:enter_komputer_movies/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Titik masuk utama untuk Aplikasi Film.
///
/// Fungsi ini menginisialisasi dan menjalankan widget [MyApp].
void main() {
  runApp(const MyApp());
}

/// Widget aplikasi utama.
///
/// Widget ini mengatur [MultiProvider] untuk injeksi dependensi,
/// mengkonfigurasi tema aplikasi, dan mendefinisikan rute navigasi.
class MyApp extends StatelessWidget {
  /// Membuat widget [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// Menyediakan [MovieProvider] untuk pohon widget.
        ChangeNotifierProvider(
          create: (_) => MovieProvider(ApiService()),
        ),

        /// Menyediakan [UserProvider] untuk pohon widget.
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Aplikasi Film',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          /// Rute ke [LoginScreen].
          '/login': (context) => const LoginScreen(),

          /// Rute ke [HomeScreen].
          '/home': (context) => const HomeScreen(),

          /// Rute ke [UserProfileContent].
          '/userProfile': (context) => const UserProfileContent(),

          /// Rute ke [DetailMovieContent] dengan [movieId] default 0.
          '/movieDetail': (context) => DetailMovieContent(movieId: 0),
        },
      ),
    );
  }
}
