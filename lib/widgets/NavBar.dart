// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_photos_test/main.dart';
import 'package:google_photos_test/pages/album_page.dart';
import 'package:google_photos_test/pages/dev_page.dart';
import 'package:google_photos_test/pages/gallery_page.dart';

final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex.value = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GalleryPage()),
      );
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AlbumPage()),
      );
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DevPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedIndex,
      builder: (context, value, child) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: 'Images',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_album),
              label: 'Albums',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.developer_board_outlined),
              label: 'Dev',
            ),
          ],
          currentIndex: value,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        );
      }
    );
  }
}