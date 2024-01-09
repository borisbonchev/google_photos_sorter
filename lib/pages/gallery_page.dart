// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:google_photos_test/pages/photoview_page.dart';
import 'package:google_photos_test/services/img_requests.dart';
import 'package:google_photos_test/services/logging.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: PhotoRequests().returnAllImageUrls(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        } else if (snapshot.hasError) {
          return _buildError(snapshot.error.toString());
        } else {
          List<String> photos = snapshot.data ?? [];

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Expanded(child: Text('Gallery')),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _handleImageSelection(context),
                  ),
                ],
              ),
            ),
            body: _buildGallery(photos, context),
          );
        }
      },
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(String errorMessage) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: Center(child: Text('Error: $errorMessage')),
    );
  }

  Widget _buildGallery(List<String> photos, BuildContext context) {
    return GridView.builder(
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
              child: Image.network(
                photos[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  logger.warning('Error loading image at index $index: $error');
                  return Container(color: Colors.red.shade400);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleImageSelection(BuildContext context) async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final html.File? file = input.files?.first;
      if (file != null) {
        // uploadToGooglePhotos(file);
      }
    });
  }
}
