import 'package:flutter/material.dart';
import 'package:google_photos_test/services/photo_service.dart';

class SearchPicturesButton extends StatelessWidget {
  const SearchPicturesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          PhotoService().pictureSearch();
        },
        child: const Text('Search Pictures'),
      ),
    );
  }
}

class FindAlbumByIdButton extends StatelessWidget {
  const FindAlbumByIdButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          PhotoService().searchMediaItems();
        },
        child: const Text('Find album by id'),
      ),
    );
  }
}

class ReturnAllAlbumIdsButton extends StatelessWidget {
  const ReturnAllAlbumIdsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          PhotoService().getAlbumIds();
        },
        child: const Text('Return all album ids'),
      ),
    );
  }
}

class ReturnImgUrlsButton extends StatelessWidget {
  const ReturnImgUrlsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          PhotoService().returnImgUrls();
        },
        child: const Text('Return img urls'),
      ),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}