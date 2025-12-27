import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:myapp/firebase_options.dart';     
import 'package:myapp/home_screen.dart';
import 'package:myapp/login_screen.dart';
import 'package:myapp/providers/favorite_provider.dart';
import 'package:myapp/signup_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  // Pastikan semua widget binding sudah siap sebelum menjalankan kode native
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKos - Cari Kosan Impian',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins', // Menggunakan font Poppins
      ),
      // Gunakan initialRoute dan routes untuk navigasi yang lebih terstruktur
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        // Anda bisa menambahkan rute lain di sini
      },
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
    );
  }
}
