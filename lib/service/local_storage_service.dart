import 'package:shared_preferences/shared_preferences.dart';

/// Layanan untuk menyimpan dan mengelola data lokal menggunakan [SharedPreferences].
///
/// Kelas ini menyediakan metode untuk menambahkan, menghapus, dan mengambil
/// film dari watchlist dan favorit.
class LocalStorageService {
  static const _watchlistKey = 'watchlist';
  static const _favoritesKey = 'favorites';

  /// Menambahkan film ke watchlist.
  ///
  /// [movieId] adalah ID dari film yang akan ditambahkan.
  Future<void> addMovieToWatchlist(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final watchlist = prefs.getStringList(_watchlistKey) ?? [];
    watchlist.add(movieId.toString());
    await prefs.setStringList(_watchlistKey, watchlist);
  }

  /// Menghapus film dari watchlist.
  ///
  /// [movieId] adalah ID dari film yang akan dihapus.
  Future<void> removeMovieFromWatchlist(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final watchlist = prefs.getStringList(_watchlistKey) ?? [];
    watchlist.remove(movieId.toString());
    await prefs.setStringList(_watchlistKey, watchlist);
  }

  /// Mengambil daftar ID film dari watchlist.
  ///
  /// Mengembalikan daftar ID film sebagai [List<int>].
  Future<List<int>> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final watchlist = prefs.getStringList(_watchlistKey) ?? [];
    return watchlist.map((id) => int.parse(id)).toList();
  }

  /// Menambahkan film ke favorit.
  ///
  /// [movieId] adalah ID dari film yang akan ditambahkan.
  Future<void> addMovieToFavorites(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.add(movieId.toString());
    await prefs.setStringList(_favoritesKey, favorites);
  }

  /// Menghapus film dari favorit.
  ///
  /// [movieId] adalah ID dari film yang akan dihapus.
  Future<void> removeMovieFromFavorites(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.remove(movieId.toString());
    await prefs.setStringList(_favoritesKey, favorites);
  }

  /// Mengambil daftar ID film dari favorit.
  ///
  /// Mengembalikan daftar ID film sebagai [List<int>].
  Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.map((id) => int.parse(id)).toList();
  }
}
