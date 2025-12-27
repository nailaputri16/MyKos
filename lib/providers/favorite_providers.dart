import 'package:flutter/material.dart';
import 'package:myapp/models/kos.dart';

// `ChangeNotifier` adalah kelas inti dari Flutter SDK.
// Kelas ini menyediakan fungsionalitas untuk "memberi tahu" para pendengarnya (listeners)
// ketika ada perubahan yang terjadi. Dalam kasus ini, `FavoriteProvider` akan memberi tahu
// widget-widget yang mendengarkannya (seperti `DetailScreen` dan `FavoritesScreen`)
// setiap kali daftar favorit diubah (ditambah atau dihapus).
class FavoriteProvider with ChangeNotifier {
  // `_favoriteKos` adalah daftar pribadi (private, ditandai dengan `_`)
  // yang menyimpan semua objek `Kos` yang telah ditandai sebagai favorit.
  final List<Kos> _favoriteKos = [];

  // Ini adalah "getter" publik yang memungkinkan bagian lain dari aplikasi
  // untuk mengakses daftar favorit tanpa bisa mengubahnya secara langsung.
  // Ini adalah praktik enkapsulasi yang baik.
  List<Kos> get favoriteKos => _favoriteKos;

  // Metode ini memeriksa apakah sebuah `Kos` sudah ada di dalam daftar favorit.
  // Ini berguna untuk menentukan apakah ikon hati harus ditampilkan terisi atau kosong.
  bool isFavorite(Kos kos) {
    return _favoriteKos.contains(kos);
  }

  // Metode ini menangani logika utama: menambah atau menghapus favorit.
  void toggleFavorite(Kos kos) {
    if (isFavorite(kos)) {
      // Jika kos sudah favorit, hapus dari daftar.
      _favoriteKos.remove(kos);
    } else {
      // Jika belum favorit, tambahkan ke daftar.
      _favoriteKos.add(kos);
    }
    
    // Ini adalah bagian terpenting dari `ChangeNotifier`.
    // `notifyListeners()` akan memancarkan sinyal ke semua widget yang mendengarkan provider ini.
    // Ketika sinyal ini diterima, widget-widget tersebut akan tahu bahwa mereka perlu 
    // membangun ulang (rebuild) UI mereka untuk mencerminkan data yang baru.
    // Misalnya, ikon hati akan berubah, atau daftar di halaman favorit akan diperbarui.
    notifyListeners();
  }
}
