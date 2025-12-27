import 'package:flutter/material.dart';
import 'package:myapp/detail_screen.dart';
import 'package:myapp/models/kos.dart';
import 'package:myapp/profile_screen.dart';
import 'package:myapp/search_screen.dart';
import 'package:myapp/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Menambahkan properti `type` pada setiap data kos
  final List<Kos> _allKos = const [
    Kos(
      name: 'D\'Sakura House',
      address: 'Jl.Bumimanti IV, Kampung Baru',
      imagePath: 'assets/images/kos_sakura.png',
      price: 'Rp 850.000 / bulan',
      facilities: ['K. Mandi Dalam', 'AC', 'Wi-Fi', 'Kasur', 'Lemari'],
      description: 'Kos khusus putri dengan lingkungan yang aman dan nyaman. Lokasi strategis dekat dengan pusat perbelanjaan dan kampus. Tersedia dapur bersama dan area parkir motor.',
      phoneNumber: '089635512295',
      type: 'Putri',
    ),
    Kos(
      name: 'Perumahan KHR',
      address: 'Jl.Panglima Polim, Segala Mider',
      imagePath: 'assets/images/kos_khr.png',
      price: 'Rp 1.200.000 / bulan',
      facilities: ['K. Mandi Dalam', 'AC', 'Wi-Fi', 'TV Kabel', 'Parkir Mobil'],
      description: 'Kos eksklusif dengan fasilitas lengkap. Setiap kamar dilengkapi dengan perabotan modern dan kamar mandi pribadi. Keamanan 24 jam dan akses mudah ke jalan utama.',
      phoneNumber: '089635512295',
      type: 'Campur',
    ),
    Kos(
      name: 'Kos Griya Delicia',
      address: 'Alamat sawah baru, Belakang Unila',
      imagePath: 'assets/images/kos_delicia.png',
      price: 'Rp 700.000 / bulan',
      facilities: ['K. Mandi Luar', 'Wi-Fi', 'Kasur', 'Dapur Bersama'],
      description: 'Kos ekonomis untuk mahasiswa, berjarak jalan kaki ke Universitas Lampung. Suasana tenang, cocok untuk belajar. Harga sudah termasuk listrik dan air.',
      phoneNumber: '089635512295',
      type: 'Putra',
    ),
    Kos(
      name: 'KOST WAFTA',
      address: 'Belakang MCD UBL, Kedaton',
      imagePath: 'assets/images/kos_wafta.png',
      price: 'Rp 950.000 / bulan',
      facilities: ['K. Mandi Dalam', 'AC', 'Wi-Fi', 'Meja Belajar'],
      description: 'Kos modern di pusat kota, dekat dengan Universitas Bandar Lampung dan berbagai kafe. Desain kamar minimalis dan nyaman untuk istirahat.',
      phoneNumber: '089635512295',
      type: 'Putri',
    ),
    Kos(
      name: 'Muli Kos',
      address: 'Jl.Bumimanti III, Kampung Baru',
      imagePath: 'assets/images/muli_kos.png',
      price: 'Rp 900.000 / bulan',
      facilities: ['K. Mandi Dalam', 'AC', 'Wi-Fi', 'Kasur', 'Lemari'],
      description: 'Kos khusus putri dengan lingkungan yang aman dan nyaman. Lokasi strategis dekat dengan pusat perbelanjaan dan kampus. Tersedia dapur bersama dan area parkir motor.',
      phoneNumber: '082176702655',
      type: 'Putri',
    ),
    Kos(
      name: 'Kos Dahlia',
      address: 'Jl.Wijaya Kusuma, Kampung Baru',
      imagePath: 'assets/images/kos_dahlia.png',
      price: 'Rp 700.000 / bulan',
      facilities: ['K. Mandi Dalam', 'AC', 'Wi-Fi', 'Kasur', 'Lemari'],
      description: 'Kos khusus putri dengan lingkungan yang aman dan nyaman. Lokasi strategis dekat dengan pusat perbelanjaan dan kampus. Tersedia dapur bersama dan area parkir motor.',
      phoneNumber: '082176702655',
      type: 'Putri',
    ),
    Kos(
      name: 'Kos Mawar',
      address: 'Jl.Palapa 2, Kedaton',
      imagePath: 'assets/images/kos_mawar.png',
      price: 'Rp 500.000 / bulan',
      facilities: ['K. Mandi Dalam', 'Wi-Fi', 'Kasur', 'Lemari'],
      description: 'Kos khusus putri dengan lingkungan yang aman dan nyaman. Lokasi strategis dekat dengan pusat perbelanjaan dan kampus. Tersedia dapur bersama dan area parkir motor.',
      phoneNumber: '082176702655',
      type: 'Putri',
    ),
    Kos(
      name: 'Kos Jordan',
      address: 'Jl.Bumimanti I, Kampung Baru',
      imagePath: 'assets/images/kos_jordan.png',
      price: 'Rp 950.000 / bulan',
      facilities: ['K. Mandi Dalam', 'AC', 'Wi-Fi', 'Kasur', 'Lemari'],
      description: 'Kos khusus putra dengan lingkungan yang aman dan nyaman. Lokasi strategis dekat dengan pusat perbelanjaan dan kampus. Tersedia dapur bersama dan area parkir motor.',
      phoneNumber: '081276702655',
      type: 'Putra',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      HomeScreenContent(kosList: _allKos),
      SearchScreen(allKos: _allKos),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border_outlined), activeIcon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

// -- Sisa kode HomeScreenContent tetap sama --
class HomeScreenContent extends StatelessWidget {
  final List<Kos> kosList;
  const HomeScreenContent({super.key, required this.kosList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyKos', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
        backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/welcome_banner.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Selamat Datang\nTemukan kosan impianmu\ndengan mudah',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 10.0, color: Colors.black54, offset: Offset(2.0, 2.0))]),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.8),
                itemCount: kosList.length,
                itemBuilder: (context, index) {
                  final kos = kosList[index];
                  return _buildKosCard(context, kos);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKosCard(BuildContext context, Kos kos) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailScreen(kos: kos)));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        shadowColor: Colors.black26,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'kosImage-${kos.name}',
                child: Image.asset(
                  kos.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image_outlined, size: 50, color: Colors.grey)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kos.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(kos.address, style: TextStyle(fontSize: 12, color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
