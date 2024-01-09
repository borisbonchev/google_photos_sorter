import 'package:flutter/material.dart';
import 'package:google_photos_test/services/album_requests.dart';
import 'package:google_photos_test/services/img_requests.dart';

final PhotoRequests _photoService = PhotoRequests();
final AlbumRequests _albumService = AlbumRequests();
List<String> photoIdList = [
  'AEHElZw1SRi6uNhCN60SRjEhSUlT0HbmI7Qa54p9As8vHgYG6FCoq0vF3z7IMaCILq4KNS_5Ms30u2ynEFQ89QXY9PpcfneOWw',
  'AEHElZzKm0lhRlKZBCjZPQJADT662rI9MytDL8SyJuGCTERYCt_m9PHkEDmXy1bOPHlcq721EEH9RY-PU_D2-_hcd4Oonvfj4w',
];

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
        child: const Text('Return all album names'),
      ),
    );
  }
}

class AddPhotosToAlbumButton extends StatelessWidget {
  const AddPhotosToAlbumButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          _albumService.addPhotosToAlbum(
            'AEHElZz6XH763_yIefG6hvxcEpGemuuYNItkcHxI9pmXcW_IxiVvfD0QwEDzmJgluD-NQpQTWA9j',
            photoIdList,
          );
        },
        child: const Text('Add photos to album'),
      ),
    );
  }
}

class ReturnImageUrls extends StatelessWidget {
  const ReturnImageUrls({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          _photoService.returnAllImageUrls();
        },
        child: const Text('Return img urls'),
      ),
    );
  }
}

class UploadPhotos extends StatelessWidget {
  const UploadPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          _photoService.uploadImage('assets/images/black.jpeg');
        },
        child: const Column(
          children: [
            Text('Upload Photos'),
          ],
        ),
      ),
    );
  }
}
