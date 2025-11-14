import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          // Увеличенная шапка профиля
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 30, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF6B8E23),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                // Круглое фото профиля с возможностью выбора
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                color: Color(0xFF6B8E23),
                                size: 50,
                              ),
                      ),
                      // Иконка редактирования поверх фото
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B8E23),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Имя
                const Text(
                  'Assylkhan Kerey',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                // Email
                const Text(
                  'assylkhan.kerey@nu.edu.kz',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Остальная часть профиля - смещена вниз
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menu Items - с иконками как в Figma
                  _buildMenuTile('Edit Profile', Icons.edit),
                  _buildDividerWithPadding(),
                  _buildMenuTile('Settings', Icons.settings),
                  _buildDividerWithPadding(),
                  _buildMenuTile('Help & Support', Icons.help_outline),
                  _buildDividerWithPadding(),
                  // Logout
                  _buildLogoutTile(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(String title, IconData icon) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF6B8E23).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF6B8E23), size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[500]),
      onTap: () {},
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.logout, color: Colors.red[600], size: 22),
      ),
      title: Text(
        'Logout',
        style: TextStyle(
          fontSize: 17,
          color: Colors.red[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[500]),
      onTap: () {
        // TODO: Добавить логику выхода
      },
    );
  }

  Widget _buildDividerWithPadding() {
    return Padding(
      padding: const EdgeInsets.only(left: 58, right: 16),
      child: Divider(
        height: 1,
        color: Colors.grey[300],
      ),
    );
  }
}