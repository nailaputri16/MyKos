import 'package:flutter/material.dart';
import 'package:myapp/detail_screen.dart';
import 'package:myapp/models/kos.dart';
import 'package:myapp/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreenContent(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 204, 255),
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  // Daftar data kos menggunakan model Kos
  final List<Kos> kosList = const [
    Kos(
      name: 'D\'Sakura House',
      address: 'Jl.Bumimanti IV, Kampung Baru',
      imagePath: 'assets/images/kos_sakura.png',
      price: 'Rp 850.000 / bulan',
      facilities: ['K. Mandi Dalam', 'AC', 'Wi-Fi', 'Kasur', 'Lemari'],
      description: 'Kos khusus putri dengan lingkungan yang aman dan nyaman. Lokasi strategis dekat dengan pusat perbelanjaan dan kampus. Tersedia dapur bersama dan area parkir motor.',
    ),
    Kos(
      name: 'Perumahan KHR',
      address: 'Jl.Panglima Polim, Segala Mider',
      imagePath: 'assets/images/kos_khr.png',
      price: 'Rp 1.200.000 / bulan',
      facilities: ['K. Mandi Dalam', 'AC', 'Wi-Fi', 'TV Kabel', 'Parkir Mobil'],
      description: 'Kos eksklusif dengan fasilitas lengkap. Setiap kamar dilengkapi dengan perabotan modern dan kamar mandi pribadi. Keamanan 24 jam dan akses mudah ke jalan utama.',
    ),
    Kos(
      name: 'Kos Griya Delicia',
      address: 'Alamat sawah baru, Belakang Unila',
      imagePath: 'assets/images/kos_delicia.png',
      price: 'Rp 700.000 / bulan',
      facilities: ['K. Mandi Luar', 'Wi-Fi', 'Kasur', 'Dapur Bersama'],
      description: 'Kos ekonomis untuk mahasiswa, berjarak jalan kaki ke Universitas Lampung. Suasana tenang, cocok untuk belajar. Harga sudah termasuk listrik dan air.',
    ),
    Kos(
      name: 'KOST WAFTA',
      address: 'Belakang MCD UBL, Kedaton',
      imagePath: 'assets/images/kos_wafta.png',
      price: 'Rp 950.000 / bulan',
      facilities: ['K. Mandi Dalam', 'AC', 'Wi-Fi', 'Meja Belajar'],
      description: 'Kos modern di pusat kota, dekat dengan Universitas Bandar Lampung dan berbagai kafe. Desain kamar minimalis dan nyaman untuk istirahat.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyKos', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
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
                  image: const DecorationImage(
                    image: AssetImage('assets/images/welcome_banner.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black26,
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Selamat Datang\nTemukan kosan impianmu\ndengan mudah',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black54,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Grid of Kos Listings
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailScreen(kos: kos),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        shadowColor: Colors.black26,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'kosImage-${kos.name}', // Tag unik untuk Hero
                child: Image.asset(
                  kos.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image_outlined, size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kos.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kos.address,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
