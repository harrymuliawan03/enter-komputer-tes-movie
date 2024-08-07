import 'package:enter_komputer_movies/modules/home/presentasion/home_content.dart';
import 'package:flutter/material.dart';

/// Layar beranda.
///
/// Kelas ini adalah widget stateless yang menampilkan konten beranda
/// menggunakan [HomeContent].
class HomeScreen extends StatelessWidget {
  /// Membuat instance dari [HomeScreen].
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeContent();
  }
}
