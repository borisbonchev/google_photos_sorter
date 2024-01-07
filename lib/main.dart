import 'package:flutter/material.dart';
import 'package:google_photos_test/pages/navbar/NavBar.dart';
import 'package:google_photos_test/widgets/unsorted_photos_gallery.dart';
import 'package:google_photos_test/services/photo_service.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<List<String>> imageUrlsFuture;
  final PhotoService _photoService = PhotoService();
  bool showImageGallery = true;

  @override
  void initState() {
    super.initState();
    imageUrlsFuture = _photoService.filterPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, value, child) {
          return Row(
            children: [
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showImageGallery = !showImageGallery;
                      });
                    },
                    child: Text(showImageGallery ? 'Hide Images' : 'Show Images'),
                  ),
                ),
              ),
              if (showImageGallery)
                Expanded(
                  flex: 2,
                  child: FutureBuilder<List<String>>(
                    future: imageUrlsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return UnsortedImagesGallery(imageUrls: snapshot.data!);
                      }
                    },
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}