import 'package:flutter/material.dart';
import 'package:myapp/detail_screen.dart';
import 'package:myapp/models/kos.dart';

class SearchScreen extends StatefulWidget {
  final List<Kos> allKos;
  const SearchScreen({super.key, required this.allKos});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

// Enum untuk mempermudah pengelolaan state filter jenis
enum KosTypeFilter { none, putra, putri, campur }

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Kos> _filteredKos = [];

  // State untuk menyimpan filter yang aktif
  bool _sortByPrice = false;
  bool _filterByAC = false;
  KosTypeFilter _typeFilter = KosTypeFilter.none;

  @override
  void initState() {
    super.initState();
    _filteredKos = widget.allKos;
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyFilters);
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi utama untuk menerapkan semua filter yang aktif
  void _applyFilters() {
    List<Kos> tempResult = widget.allKos;
    final query = _searchController.text.toLowerCase();

    setState(() {
      // 1. Filter berdasarkan Teks Pencarian
      if (query.isNotEmpty) {
        tempResult = tempResult.where((kos) {
          final nameLower = kos.name.toLowerCase();
          final addressLower = kos.address.toLowerCase();
          return nameLower.contains(query) || addressLower.contains(query);
        }).toList();
      }

      // 2. Filter berdasarkan Jenis Kos
      if (_typeFilter != KosTypeFilter.none) {
        tempResult = tempResult.where((kos) {
          if (_typeFilter == KosTypeFilter.putra) return kos.type == 'Putra';
          if (_typeFilter == KosTypeFilter.putri) return kos.type == 'Putri';
          if (_typeFilter == KosTypeFilter.campur) return kos.type == 'Campur';
          return true;
        }).toList();
      }

      // 3. Filter berdasarkan Fasilitas (AC)
      if (_filterByAC) {
        tempResult = tempResult.where((kos) => kos.facilities.contains('AC')).toList();
      }

      // 4. Urutkan berdasarkan Harga (Termurah ke Termahal)
      if (_sortByPrice) {
        tempResult.sort((a, b) {
          // Ekstrak angka dari string harga
          int priceA = int.parse(a.price.replaceAll(RegExp(r'[^0-9]'), ''));
          int priceB = int.parse(b.price.replaceAll(RegExp(r'[^0-9]'), ''));
          return priceA.compareTo(priceB);
        });
      }

      _filteredKos = tempResult;
    });
  }

  // Fungsi untuk toggle filter jenis dan pastikan hanya satu yang aktif
  void _toggleTypeFilter(KosTypeFilter filter) {
    setState(() {
      if (_typeFilter == filter) {
        _typeFilter = KosTypeFilter.none; // Batalkan jika dipilih lagi
      } else {
        _typeFilter = filter; // Pilih yang baru
      }
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        hintText: 'Ketik lokasi atau nama kos',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15)),
                  ),
                  const SizedBox(height: 20),
                  const Text('Cari Kos Berdasarkan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(spacing: 10, children: [
                    _buildFilterChip('Harga Termurah', _sortByPrice, (selected) => setState(() {
                          _sortByPrice = selected;
                          _applyFilters();
                        })),
                    _buildFilterChip('Ada AC', _filterByAC, (selected) => setState(() {
                          _filterByAC = selected;
                          _applyFilters();
                        })),
                    // Chip khusus untuk Jenis dengan logika toggle
                    FilterChip(label: const Text('Putri'), selected: _typeFilter == KosTypeFilter.putri, onSelected: (s) => _toggleTypeFilter(KosTypeFilter.putri)),
                    FilterChip(label: const Text('Putra'), selected: _typeFilter == KosTypeFilter.putra, onSelected: (s) => _toggleTypeFilter(KosTypeFilter.putra)),
                    FilterChip(label: const Text('Campur'), selected: _typeFilter == KosTypeFilter.campur, onSelected: (s) => _toggleTypeFilter(KosTypeFilter.campur)),
                  ]),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 1),
            Expanded(
              child: _filteredKos.isEmpty
                  ? const Center(child: Text('Tidak ada kos yang cocok.', style: TextStyle(fontSize: 16, color: Colors.grey)))
                  : ListView.builder(
                      itemCount: _filteredKos.length,
                      itemBuilder: (context, index) {
                        final kos = _filteredKos[index];
                        return _buildKosListItem(context, kos);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Function(bool) onSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue.shade800,
    );
  }

  Widget _buildKosListItem(BuildContext context, Kos kos) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailScreen(kos: kos))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(kos.imagePath, width: 90, height: 90, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.house, size: 90, 
              color: Colors.grey))),
          const SizedBox(width: 16),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(kos.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Text(kos.address, style: TextStyle(fontSize: 14, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Text(kos.price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber.shade800)),
          ]))
        ]),
      ),
    );
  }
}
