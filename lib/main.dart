import 'package:flutter/material.dart';
import 'package:google_photos_test/pages/navbar/NavBar.dart';
import 'package:google_photos_test/services/logging.dart';
import 'package:google_photos_test/widgets/unsorted_image_gallery.dart';
import 'package:google_photos_test/services/img_requests.dart';

void main() {
  setupLogger();
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
  final PhotoRequests _photoService = PhotoRequests();
  Future<List<String>>? imageUrlsFuture;
  bool showImageGallery = false;

  Future<List<String>> fetchImageUrls() async {
    return _photoService.filterPhotos();
  }

  void refreshImages() {
    setState(() {
      imageUrlsFuture =
          null; // Reset imageUrlsFuture to null so it can be refetched
    });
    // Refetch image URLs
    imageUrlsFuture = fetchImageUrls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, value, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showImageGallery = !showImageGallery;
                            if (showImageGallery && imageUrlsFuture == null) {
                              imageUrlsFuture = fetchImageUrls();
                            }
                          });
                        },
                        child: Text(
                            showImageGallery ? 'Hide Images' : 'Show Images'),
                      ),
                      if (showImageGallery)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: refreshImages,
                            child: const Text('Refresh Images'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (showImageGallery)
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      if (imageUrlsFuture == null)
                        const Expanded(
                          flex: 2,
                          child: Center(child: Text('Loading images...')),
                        ),
                      if (imageUrlsFuture != null)
                        Expanded(
                          flex: 2,
                          child: FutureBuilder<List<String>>(
                            future: imageUrlsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                return UnsortedImagesGallery(
                                    imageUrls: snapshot.data!);
                              }
                            },
                          ),
                        ),
                    ],
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
