
// Kelas `Kos` ini bertindak sebagai "blueprint" atau model data.
// Tujuannya adalah untuk mendefinisikan struktur data yang jelas untuk setiap entitas "kos".
// Dengan menggunakan model ini, kita memastikan konsistensi data di seluruh aplikasi
// dan mengurangi risiko kesalahan pengetikan (typo) pada nama field.
class Kos {
  // `final` berarti nilai dari properti ini tidak bisa diubah setelah objek `Kos` dibuat.
  // Ini mempromosikan imutabilitas, yang merupakan praktik baik dalam Flutter.
  final String name;
  final String address;
  final String imagePath;
  final String price;
  final List<String> facilities;
  final String description;
  final String phoneNumber;
  final String type; // Properti baru untuk jenis kos (Putra, Putri, Campur)

  // Konstruktor `const` memungkinkan Flutter untuk melakukan optimasi saat kompilasi.
  // Widget yang dibuat dengan konstruktor `const` dapat di-cache dan digunakan kembali.
  const Kos({
    required this.name,
    required this.address,
    required this.imagePath,
    required this.price,
    required this.facilities,
    required this.description,
    required this.phoneNumber,
    required this.type, // Tambahkan di konstruktor
  });
}
