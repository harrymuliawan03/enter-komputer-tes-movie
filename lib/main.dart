import 'package:enter_komputer_movies/modules/detail_movie/presentation/detail_movie_content.dart';
import 'package:enter_komputer_movies/modules/home/presentasion/home_content.dart';
import 'package:enter_komputer_movies/modules/user_profile/presentasion/user_profile_content.dart';
import 'package:enter_komputer_movies/providers/movie_provider.dart';
import 'package:enter_komputer_movies/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieProvider(ApiService()),
        ),
      ],
      child: MaterialApp(
        title: 'Movie App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeContent(),
        routes: {
          '/userProfile': (context) => const UserProfileContent(),
          '/movieDetail': (context) =>
              DetailMovieContent(movieId: 0), // Example with dummy movieId
        },
      ),
    );
  }
}
