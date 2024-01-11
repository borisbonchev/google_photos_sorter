import 'package:flutter/material.dart';
import 'package:google_photos_test/widgets/navbar.dart';
import 'package:google_photos_test/services/logging.dart';
import 'package:google_photos_test/widgets/unsorted_image_gallery.dart';
import 'package:google_photos_test/services/img_requests.dart';

void main() {
  setupLogger(); // Setup logger for debugging
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

  // Used for passing the image ids and urls to the unsorted_image_gallery widget
  Future<List<String>>? imageUrlsFuture;
  late Future<List<String>> imageIdsFuture;
  
  // Toggle show unsorted image gallery
  bool showImageGallery = false;

  @override
  void initState() {
    super.initState();
    imageIdsFuture = fetchImageIds(); // Fetch imageIds once on initialization
  }

  // Returns only the ids from the imageData Map
  Future<List<String>> fetchImageIds() async {
    Map<String, String> imageUrlIdMap = await _photoService.filterPhotos();

    List<String> imageIds = imageUrlIdMap.values.toList();
    return imageIds;
  }

  // Returns only the urls from the imageData Map
  Future<List<String>> fetchImageUrls() async {
    Map<String, String> imageUrlIdMap = await _photoService.filterPhotos();

    List<String> imageUrls = imageUrlIdMap.keys.toList();
    return imageUrls;
  }

  // Refresh both ids and urls when the refresh button is pressed!
  // otherwise i get errors with the widget
  void refreshImages() {
    setState(() {
      imageUrlsFuture = null;
    });

    // Refetch image URLs
    imageIdsFuture = fetchImageIds();
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
                            child: const Text('Refresh'),
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
                                return const Center(
                                    child: Text('No photos found.1'));
                              } else {
                                return FutureBuilder<List<String>>(
                                  future: imageIdsFuture,
                                  builder: (context, idsSnapshot) {
                                    if (idsSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (idsSnapshot.hasError) {
                                      return const Center(
                                          child: Text('No photos found.2'));
                                    } else {
                                      return UnsortedImagesGallery(
                                        imageUrls: snapshot.data!,
                                        imageIds: idsSnapshot.data!,
                                      );
                                    }
                                  },
                                );
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
