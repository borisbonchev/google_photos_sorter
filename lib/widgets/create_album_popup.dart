import 'package:flutter/material.dart';
import 'package:google_photos_test/services/album_requests.dart';
import 'package:logging/logging.dart';

class AlbumDialog {
  final _logger = Logger('AlbumDialog');

  void showCreateAlbumDialog(BuildContext context,
      AlbumRequests albumService) {
    String albumName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Album'),
          content: TextField(
            onChanged: (value) {
              albumName = value;
            },
            decoration: const InputDecoration(hintText: 'Enter album name'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (albumName.isNotEmpty) {
                  try {
                    albumService.createAlbum(albumName);
                    // Update imageUrlsFuture to fetch new images after album creation
                    // refreshImages();
                    _logger.info('Album created: $albumName');
                  } catch (e) {
                    _logger.warning('Error creating album: $e');
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
