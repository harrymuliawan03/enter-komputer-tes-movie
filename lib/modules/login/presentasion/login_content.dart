import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enter_komputer_movies/providers/user_provider.dart';

/// Layar login untuk aplikasi Enter Komputer Movies.
///
/// Layar ini memungkinkan pengguna untuk login dengan nama mereka atau
/// sebagai tamu. Pengguna dapat memasukkan nama mereka untuk login atau
/// memilih untuk login sebagai tamu. Nama pengguna yang dimasukkan akan
/// disimpan dalam [UserProvider] dan pengguna akan diarahkan ke layar
/// beranda jika login berhasil.
class LoginContent extends StatelessWidget {
  /// Kontroler teks untuk nama pengguna.
  final TextEditingController _nameController = TextEditingController();

  /// Membuat instance dari [LoginContent].
  LoginContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Enter Komputer Movies',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                if (name.isNotEmpty) {
                  // Menyimpan nama pengguna dan mengarahkan ke layar beranda.
                  Provider.of<UserProvider>(context, listen: false)
                      .setUserName(name);
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  // Menampilkan snackbar jika nama tidak diisi.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your name'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Login as User',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Mengarahkan ke layar beranda sebagai tamu.
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Login as Guest',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
