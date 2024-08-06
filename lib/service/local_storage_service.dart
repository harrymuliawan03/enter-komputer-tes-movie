import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _watchlistKey = 'watchlist';
  static const _favoritesKey = 'favorites';

  Future<void> addMovieToWatchlist(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final watchlist = prefs.getStringList(_watchlistKey) ?? [];
    watchlist.add(movieId.toString());
    await prefs.setStringList(_watchlistKey, watchlist);
  }

  Future<void> removeMovieFromWatchlist(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final watchlist = prefs.getStringList(_watchlistKey) ?? [];
    watchlist.remove(movieId.toString());
    await prefs.setStringList(_watchlistKey, watchlist);
  }

  Future<List<int>> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final watchlist = prefs.getStringList(_watchlistKey) ?? [];
    return watchlist.map((id) => int.parse(id)).toList();
  }

  Future<void> addMovieToFavorites(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.add(movieId.toString());
    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<void> removeMovieFromFavorites(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.remove(movieId.toString());
    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.map((id) => int.parse(id)).toList();
  }
}
