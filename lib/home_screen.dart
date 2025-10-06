import 'package:flutter/material.dart';
import 'package:myapp/profile_screen.dart'; // Impor halaman profil

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan
  static const List<Widget> _widgetOptions = <Widget>[
    HomeContent(), // Konten utama halaman beranda
    Scaffold(body: Center(child: Text('Halaman Pencarian'))), // Halaman Search
    Scaffold(body: Center(child: Text('Halaman Favorit'))), // Halaman Favorites
    ProfileScreen(), // Halaman Profil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tampilkan body berdasarkan indeks yang dipilih
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Widget baru untuk memisahkan konten utama halaman beranda
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('07:00 AM', style: TextStyle(fontSize: 14)),
        actions: [
          IconButton(icon: const Icon(Icons.signal_cellular_alt), onPressed: () {}),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Welcome Banner
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[400], // Placeholder untuk banner
                ),
                child: const Center(
                  child: Text(
                    'Selamat Datang\nTemukan kosan impianmu\ndengan mudah',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Grid of Kos Listings
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
                children: [
                  _buildKosCard(
                    'D\'Sakura House',
                    'Jl.Bumimanti IV\nKampung Baru',
                  ),
                  _buildKosCard(
                    'Perumahan KHR',
                    'Jl.Panglima Polim, Segala Mider',
                  ),
                  _buildKosCard(
                    'Kos Griya Delicia',
                    'Alamat sawah baru\nBelakang Unila',
                  ),
                  _buildKosCard(
                    'KOST WAFTA',
                    'Belakang MCD UBL\nkedaton',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKosCard(String title, String address) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                color: Colors.grey[300], // Placeholder untuk gambar kos
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.white, size: 40),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis,),
                const SizedBox(height: 4),
                Text(address, style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
