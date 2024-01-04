import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:google_photos_test/pages/PhotoViewPage.dart";
import "package:google_photos_test/services/photo_service.dart";

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: PhotoService().returnAllImageUrls(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Gallery')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Gallery')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          List<String> photos = snapshot.data ?? [];
          
          return Scaffold(
            appBar: AppBar(title: const Text('Gallery')),
            body: GridView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.all(1),
              itemCount: photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(0.5),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PhotoViewPage(
                          photos: photos,
                          index: index,
                        ),
                      ),
                    ),
                    child: Hero(
                      tag: photos[index],
                      child: CachedNetworkImage(
                        imageUrl: photos[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey),
                        errorWidget: (context, url, error) {
                          print('Error loading image at index $index: $error');
                          return Container(color: Colors.red.shade400);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
