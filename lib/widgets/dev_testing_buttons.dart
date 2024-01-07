import 'package:flutter/material.dart';
import 'package:google_photos_test/services/album_requests.dart';
import 'package:google_photos_test/services/img_requests.dart';

final PhotoRequests _photoService = PhotoRequests();
final AlbumRequests _albumService = AlbumRequests();

class ReturnAllAlbumIdsButton extends StatelessWidget {
  const ReturnAllAlbumIdsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          _albumService.getAlbumIds();
        },
        child: const Text('Return all album ids'),
      ),
    );
  }
}

class TestButton extends StatelessWidget {
  const TestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          _albumService.getAlbumNames();
        },
        child: const Text('Test'),
      ),
    );
  }
}