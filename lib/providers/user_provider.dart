import 'package:flutter/material.dart';

/// Penyedia data pengguna yang menggunakan [ChangeNotifier].
///
/// Kelas ini mengelola informasi pengguna, seperti nama pengguna, dan memberikan
/// kemampuan untuk memperbarui nama pengguna serta melakukan logout. Perubahan
/// pada data pengguna akan memberitahu pendengar yang terdaftar.
class UserProvider with ChangeNotifier {
  /// Nama pengguna saat ini.
  String _userName = 'Guest';

  /// Mengembalikan nama pengguna saat ini.
  ///
  /// Ini adalah properti yang hanya dapat dibaca untuk mendapatkan nilai nama
  /// pengguna saat ini.
  String get userName => _userName;

  /// Mengatur nama pengguna.
  ///
  /// [name] adalah nama baru yang akan diset sebagai nama pengguna.
  /// Setelah mengubah nama pengguna, akan memberitahu pendengar tentang perubahan.
  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  /// Melakukan logout dan mengatur nama pengguna kembali ke 'Guest'.
  ///
  /// Setelah melakukan logout, akan memberitahu pendengar tentang perubahan.
  void logout() {
    _userName = 'Guest';
    notifyListeners();
  }
}
