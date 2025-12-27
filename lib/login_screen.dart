import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/signup_screen.dart';

// LoginScreen adalah StatefulWidget karena state-nya (seperti input teks dan status loading) bisa berubah.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk mengambil teks dari kolom input email dan password.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Variabel untuk melacak status proses login (untuk menampilkan loading).
  bool _isLoading = false;

  // `dispose` dipanggil saat widget dihapus dari tree untuk membersihkan resource.
  // Controller harus di-dispose untuk menghindari kebocoran memori.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi yang menangani logika saat tombol "Log in" ditekan.
  Future<void> _signIn() async {
    // Memeriksa apakah widget masih ada di tree sebelum melakukan operasi async.
    if (!mounted) return;

    // Memulai proses loading dan membangun ulang UI untuk menampilkan CircularProgressIndicator.
    setState(() {
      _isLoading = true;
    });

    // Blok try-catch untuk menangani kemungkinan error saat proses login.
    try {
      // Menggunakan Firebase Auth untuk mencoba login dengan email dan password.
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(), // Ambil teks email & hapus spasi.
        password: _passwordController.text.trim(), // Ambil teks password & hapus spasi.
      );

      // Jika login berhasil (credential.user tidak null) dan widget masih mounted.
      if (credential.user != null && mounted) {
        // Navigasi ke HomeScreen dan hapus semua rute sebelumnya.
        // Ini mencegah pengguna kembali ke halaman login setelah berhasil masuk.
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      // Menangkap error spesifik dari Firebase Authentication.
      String message;
      if (e.code == 'user-not-found') {
        message = 'Tidak ada pengguna yang ditemukan untuk email itu.';
      } else if (e.code == 'wrong-password') {
        message = 'Kata sandi salah.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      } else {
        message = 'Gagal masuk. Periksa kembali kredensial Anda.';
      }
      
      // Tampilkan pesan error kepada pengguna menggunakan SnackBar.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      // Menangkap error umum lainnya yang mungkin terjadi.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan yang tidak terduga.')),
        );
      }
    } finally {
      // Blok `finally` akan selalu dijalankan, baik login berhasil maupun gagal.
      if (mounted) {
        // Hentikan proses loading.
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Metode `build` untuk membangun UI dari LoginScreen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: SafeArea(
        child: Column(
          children: [
            // Bagian atas untuk logo dan judul
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.home_work, size: 80, color: Colors.black54),
                    const SizedBox(height: 10),
                    const Text(
                      'MyKos',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bagian bawah untuk form login
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32.0),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Sign in to continue.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      // Kolom input untuk email
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'EMAIL',
                          filled: true,
                          fillColor: Color(0xFFE8E8E8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // Kolom input untuk password
                      TextField(
                        controller: _passwordController,
                        obscureText: true, // Menyembunyikan teks password
                        decoration: const InputDecoration(
                          labelText: 'PASSWORD',
                          filled: true,
                          fillColor: Color(0xFFE8E8E8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      // Kondisi untuk menampilkan tombol atau loading indicator
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _signIn, // Memanggil fungsi _signIn saat ditekan
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Text(
                                'Log in',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          // Implementasi fungsionalitas lupa password
                        },
                        child: const Text(
                          'Lupa Password?',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      // Tombol untuk navigasi ke halaman pendaftaran
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          'Buat Akun',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
