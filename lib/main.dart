import 'package:flutter/material.dart';
import 'package:google_photos_test/pages/AlbumPage.dart';
import 'package:google_photos_test/pages/DevPage.dart';
import 'package:google_photos_test/pages/GalleryPage.dart';
import 'package:google_photos_test/pages/navbar/NavBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Photos upload',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, value, child) {
          return PageView(
            controller: PageController(initialPage: value),
            onPageChanged: (index) {
              selectedIndex.value = index;
            },
            children: const <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[],
                ),
              ),
              GalleryPage(),
              AlbumPage(),
              DevPage(),
            ],
          );
        },
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}