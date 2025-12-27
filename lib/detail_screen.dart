import 'package:flutter/material.dart';
import 'package:myapp/models/kos.dart';
import 'package:myapp/providers/favorite_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  final Kos kos;

  const DetailScreen({super.key, required this.kos});

  // Fungsi untuk membuka WhatsApp
  Future<void> _launchWhatsApp(String phone) async {
    final Uri url = Uri.parse("https://wa.me/$phone");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan `Consumer` untuk mendapatkan akses ke `FavoriteProvider` dan
    // secara otomatis membangun ulang widget ini saat ada perubahan.
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        // Memeriksa apakah kos ini sudah menjadi favorit
        final bool isFavorite = favoriteProvider.isFavorite(kos);

        return Scaffold(
          extendBodyBehindAppBar: true, // Membuat body bisa berada di belakang AppBar
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Colors.white),
            actions: [
              // Tombol favorit yang dinamis
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  // Memanggil metode toggleFavorite saat tombol ditekan
                  favoriteProvider.toggleFavorite(kos);

                  // Menampilkan snackbar sebagai feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isFavorite ? 'Dihapus dari Favorit' : 'Ditambahkan ke Favorit'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              // Konten utama
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Hero(
                      tag: 'kosImage-${kos.name}',
                      child: Image.asset(
                        kos.imagePath,
                        height: 350,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 350,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(kos.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(children: [const Icon(Icons.location_on, color: Colors.grey, size: 20), const SizedBox(width: 8), Expanded(child: Text(kos.address, style: const TextStyle(fontSize: 16, color: Colors.grey)))]),
                          const SizedBox(height: 12),
                          Text(kos.price, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber.shade800)),
                          const Divider(height: 40, thickness: 1),
                          const Text('Deskripsi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(kos.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                          const Divider(height: 40, thickness: 1),
                          const Text('Fasilitas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 15),
                          Wrap(spacing: 10, runSpacing: 10, children: kos.facilities.map((f) => Chip(label: Text(f))).toList()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100), // Memberi ruang untuk tombol mengapung
                  ],
                ),
              ),
              // Tombol Hubungi mengapung di bagian bawah
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)],
                  ),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                    label: const Text('Hubungi Pemilik Kos', style: TextStyle(color: Colors.white, fontSize: 18)),
                    onPressed: () => _launchWhatsApp(kos.phoneNumber),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
