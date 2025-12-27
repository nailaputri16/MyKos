
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddKosScreen extends StatefulWidget {
  const AddKosScreen({super.key});

  @override
  State<AddKosScreen> createState() => _AddKosScreenState();
}

class _AddKosScreenState extends State<AddKosScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _image;
  bool _isLoading = false;

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Fungsi untuk mengunggah data kos ke Firebase
  Future<void> _uploadKos() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan pilih gambar kos terlebih dahulu')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        // 1. Unggah gambar ke Firebase Storage
        final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final storageRef = FirebaseStorage.instance.ref().child('kos_images').child(imageName);
        await storageRef.putFile(_image!);
        final imageUrl = await storageRef.getDownloadURL();

        // 2. Simpan data kos ke Cloud Firestore
        await FirebaseFirestore.instance.collection('kos').add({
          'name': _nameController.text,
          'address': _addressController.text,
          'price': _priceController.text,
          'description': _descriptionController.text,
          'phoneNumber': _phoneController.text,
          'imagePath': imageUrl, // Simpan URL gambar dari Storage
          'ownerId': user.uid, // Simpan ID pemilik kos
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data kos berhasil ditambahkan!')),
        );
        Navigator.of(context).pop();

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gabung Sebagai Pemilik Kos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Widget untuk memilih dan menampilkan gambar
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, fit: BoxFit.cover, width: double.infinity),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Pilih Gambar Kos', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Kolom input teks
              _buildTextFormField(_nameController, 'Nama Kos'),
              _buildTextFormField(_addressController, 'Alamat Lengkap'),
              _buildTextFormField(_priceController, 'Harga per Bulan (Contoh: Rp 850.000)'),
              _buildTextFormField(_phoneController, 'Nomor Telepon (WhatsApp)'),
              _buildTextFormField(
                _descriptionController,
                'Deskripsi Kos',
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Tombol untuk menyimpan data
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _uploadKos,
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text('Simpan Data Kos'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat TextFormField
  Widget _buildTextFormField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }
}
