/// Kelas yang merepresentasikan sebuah film.
///
/// Kelas ini berisi informasi dasar tentang sebuah film termasuk
/// id, judul, deskripsi, path poster, tanggal rilis, dan rating.
class Movie {
  /// ID unik untuk setiap film.
  final int id;

  /// Judul dari film.
  final String title;

  /// Deskripsi singkat dari film.
  final String overview;

  /// Path untuk poster film.
  final String posterPath;

  /// Tanggal rilis film.
  final String releaseDate;

  /// Rating dari film.
  final double rating;

  /// Membuat sebuah instance dari [Movie].
  ///
  /// Semua parameter bersifat wajib.
  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.rating,
  });

  /// Membuat instance dari [Movie] berdasarkan data JSON.
  ///
  /// Parameter [json] adalah sebuah map yang berisi kunci dan nilai
  /// yang mencerminkan properti dari [Movie].
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      rating: json['vote_average'].toDouble(),
    );
  }
}
