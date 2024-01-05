import 'package:flutter/material.dart';
import 'package:google_photos_test/services/photo_service.dart';

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
          PhotoService().returnAllImageUrls();
        },
        child: const Text('Return img urls'),
      ),
    );
  }
}

class GetImageByIdButton extends StatelessWidget {
  const GetImageByIdButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          PhotoService().returnAllImageUrls();
        },
        child: const Text('Get Image using ID'),
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
          PhotoService().filterPhotoIds();
        },
        child: const Text('Test'),
      ),
    );
  }
}