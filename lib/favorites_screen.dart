import 'package:flutter/material.dart';
import 'package:myapp/detail_screen.dart';
import 'package:myapp/models/kos.dart';
import 'package:myapp/providers/favorite_provider.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kos Favorit Anda'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Consumer<FavoriteProvider>(
        // `Consumer` akan secara otomatis "mendengarkan" `FavoriteProvider`.
        // Setiap kali `notifyListeners()` dipanggil di provider, `builder` ini akan dijalankan lagi.
        builder: (context, favoriteProvider, child) {
          final List<Kos> favoriteKos = favoriteProvider.favoriteKos;

          // Jika daftar favorit kosong, tampilkan pesan.
          if (favoriteKos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Anda belum punya kos favorit.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tekan ikon hati di halaman detail untuk menambahkan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Jika ada daftar favorit, tampilkan dalam bentuk `ListView`.
          return ListView.builder(
            itemCount: favoriteKos.length,
            itemBuilder: (context, index) {
              final kos = favoriteKos[index];
              // Menggunakan widget yang sama dengan di halaman pencarian untuk konsistensi
              return _buildKosListItem(context, kos);
            },
          );
        },
      ),
    );
  }

  // Widget helper untuk menampilkan satu item kos favorit (mirip dengan di SearchScreen)
  Widget _buildKosListItem(BuildContext context, Kos kos) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailScreen(kos: kos)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                kos.imagePath,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.house, size: 90, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kos.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(kos.address, style: TextStyle(fontSize: 14, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text(kos.price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber.shade800)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
