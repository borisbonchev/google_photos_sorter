import 'package:flutter/material.dart';
import 'package:google_photos_test/services/api_requests.dart';

final ApiRequests _photoService = ApiRequests();

class ReturnAllAlbumIdsButton extends StatelessWidget {
  const ReturnAllAlbumIdsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          _photoService.getAlbumIds();
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
          _photoService.filterPhotos();
        },
        child: const Text('Test'),
      ),
    );
  }
}