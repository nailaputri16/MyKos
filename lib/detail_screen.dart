import 'package:flutter/material.dart';
import 'package:myapp/models/kos.dart';

class DetailScreen extends StatelessWidget {
  final Kos kos;

  const DetailScreen({super.key, required this.kos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gambar Utama dengan Animasi Hero
          Hero(
            tag: 'kosImage-${kos.name}',
            child: Image.asset(
              kos.imagePath,
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Tombol Kembali
          Positioned(
            top: 40,
            left: 10,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          // Konten Detail
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 80), // Padding bawah untuk tombol
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama dan Harga
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              kos.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            kos.price,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 5, 176, 206),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Alamat
                      Text(
                        kos.address,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 24),
                      // Deskripsi
                      const Text(
                        'Deskripsi',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        kos.description,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      // Fasilitas
                      const Text(
                        'Fasilitas',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: kos.facilities
                            .map((facility) => Chip(
                                  label: Text(facility),
                                  backgroundColor: Colors.amber.shade100,
                                  avatar: const Icon(Icons.check_circle_outline, color: Colors.amber),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Aksi untuk menghubungi pemilik (misalnya, buka WhatsApp)
        },
        label: const Text('Hubungi Pemilik', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.chat_bubble_outline),
        backgroundColor: const Color.fromARGB(255, 125, 215, 238),
      ),
    );
  }
}
