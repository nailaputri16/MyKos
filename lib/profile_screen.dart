import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'add_kos_screen.dart';
import 'dart:async'; // Import for StreamSubscription

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user = FirebaseAuth.instance.currentUser;
  String? _profileImageUrl;
  late StreamSubscription<User?> _userSubscription;

  @override
  void initState() {
    super.initState();
    _profileImageUrl = _user?.photoURL;

    _userSubscription = FirebaseAuth.instance.userChanges().listen((user) {
      if (mounted) {
        setState(() {
          _user = user;
          _profileImageUrl = user?.photoURL;
        });
      }
    }, onError: (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error checking auth state: $error')),
        );
      }
    });
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    if (_user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Anda harus login untuk mengubah foto profil.')),
        );
      }
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${_user!.uid}.jpg');

      await ref.putData(await image.readAsBytes());
      final url = await ref.getDownloadURL();

      if (FirebaseAuth.instance.currentUser != null && mounted) {
        await FirebaseAuth.instance.currentUser?.updatePhotoURL(url);
        setState(() {
          _profileImageUrl = url;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil diperbarui!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah gambar: $e')),
        );
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }
  
  Future<void> _editDisplayName() async {
    if (_user == null) return;

    final TextEditingController nameController = TextEditingController(text: _user!.displayName);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Nama Tampilan'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Masukkan nama baru"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Simpan'),
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty && newName != _user!.displayName) {
                  try {
                    await _user!.updateDisplayName(newName);
                    if (mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Nama berhasil diperbarui!')),
                       );
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                     if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text('Gagal memperbarui nama: $e')),
                       );
                     }
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
              color: Colors.lightBlue[700],
              fontWeight: FontWeight.w500,
              fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _user == null ? _buildLoginPrompt() : _buildProfileView(),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Anda belum login untuk melihat profil.',
              style: TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text('Login Sekarang'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        const SizedBox(height: 20),
        _buildProfileHeader(),
        const SizedBox(height: 40),
        _buildSectionHeader('Informasi'),
        _buildProfileMenuItem(
          icon: Icons.phone_android_outlined,
          title: '082278807081',
          onTap: () {},
        ),
        _buildProfileMenuItem(
          icon: Icons.vpn_key_outlined,
          title: 'Ubah Kata Sandi',
          onTap: () {},
        ),
        _buildProfileMenuItem(
          icon: Icons.info_outline,
          title: 'Tentang',
          onTap: () {},
        ),
        const SizedBox(height: 30),
        _buildSectionHeader('General'),
        const SizedBox(height: 15),
        _buildJoinAsOwnerButton(),
        const SizedBox(height: 30),
        _buildProfileMenuItem(
          icon: Icons.logout,
          title: 'Log Out',
          onTap: _logout,
          isLogout: true, // Special styling for logout
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
              child: _profileImageUrl == null
                  ? Icon(Icons.person, size: 60, color: Colors.grey[500])
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 4,
              child: GestureDetector(
                onTap: _pickAndUploadImage,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _user?.displayName ?? 'Alya Pardila',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.edit, size: 20, color: Colors.grey[600]),
              onPressed: _editDisplayName,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          _user?.email ?? 'alya123@gmail.com',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: Colors.grey[200],
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildJoinAsOwnerButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const AddKosScreen()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gabung Sebagai Pemilik Kos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap,
      bool isLogout = false}) {
    final color = isLogout ? Colors.red : Colors.grey[800];
    return ListTile(
      leading: Icon(icon, color: color, size: 26),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isLogout ? Colors.red : Colors.black87,
        ),
      ),
      trailing:
          isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
    );
  }
}
