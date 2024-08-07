import 'package:enter_komputer_movies/modules/user_profile/presentasion/user_profile_content.dart';
import 'package:flutter/material.dart';

/// Layar profil pengguna.
///
/// Kelas ini adalah widget stateless yang menampilkan konten profil pengguna
/// menggunakan [UserProfileContent].
class UserProfileScreen extends StatelessWidget {
  /// Membuat instance dari [UserProfileScreen].
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserProfileContent();
  }
}
