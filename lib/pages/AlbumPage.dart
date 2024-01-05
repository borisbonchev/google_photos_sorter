import 'package:flutter/material.dart';
import 'package:google_photos_test/pages/navbar/NavBar.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album Page'),
      ),
      body: Container(
        // Add your code here
      ),
      bottomNavigationBar: const NavBar()
    );
  }
}
