import 'package:enter_komputer_movies/providers/movie_provider.dart';
import 'package:enter_komputer_movies/screens/detail_movie/detail_movie_screen.dart';
import 'package:enter_komputer_movies/shared/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    movieProvider.fetchNowPlayingMovies();
    movieProvider.fetchPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
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
                  return Center(child: CircularProgressIndicator());
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
                          child: MovieCard(movie: movie),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            Padding(
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
                  return Center(child: CircularProgressIndicator());
                } else {
                  return LimitedBox(
                    maxHeight: 600,
                    child: ListView.builder(
                      itemCount: provider.popularMovies.length,
                      itemBuilder: (context, index) {
                        if (index >= 20) return Container();
                        final movie = provider.popularMovies[index];
                        return MovieCard(movie: movie);
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

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(8.0),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            child: Container(
              width: double.infinity,
              height: 200,
              child: CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Rating: ${movie.rating}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.watch_later, color: Colors.deepPurple),
                      onPressed: () {
                        movieProvider.addMovieToWatchlist(movie);
                      },
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.favorite_border, color: Colors.deepPurple),
                      onPressed: () {
                        movieProvider.addMovieToFavorites(movie);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.details, color: Colors.deepPurple),
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
