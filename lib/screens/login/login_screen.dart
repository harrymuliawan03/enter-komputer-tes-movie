import 'package:enter_komputer_movies/modules/login/presentasion/login_content.dart';
import 'package:flutter/material.dart';

/// Layar login.
///
/// Kelas ini adalah widget stateless yang menampilkan konten login
/// menggunakan [LoginContent].
class LoginScreen extends StatelessWidget {
  /// Membuat instance dari [LoginScreen].
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginContent();
  }
}
