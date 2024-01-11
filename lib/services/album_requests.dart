import 'dart:async';
import 'dart:convert';

import 'package:google_photos_test/services/authentication.dart';
import 'package:google_photos_test/services/data_mapper.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:logging/logging.dart';

class AlbumRequests {
  final AuthService _authService = AuthService();
  final DataMapper _dataMapper = DataMapper();
  final _logger = Logger('AlbumRequests');

  Future<AuthClient> getAuthClient() async {
    return await _authService.obtainAuthenticatedClient();
  }

  // Creates an empty album in Google Photos
  void createAlbum(String name) async {
    AuthClient authClient = await getAuthClient();

    var response = await authClient.post(
      Uri.parse('https://photoslibrary.googleapis.com/v1/albums'),
      body: jsonEncode({
        'album': {'title': name}
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      _logger.info('Album created successfully');
    } else {
      throw Exception('Failed to create album: ${response.statusCode}');
    }
  }

  // Adds a list of photos to an album in Google Photos
  // Completer is used to handle async calls
  Future<void> addPhotosToAlbum(String albumId, List<String> photoIds) {
    var completer = Completer<void>();

    getAuthClient().then((authClient) async {
      String jsonBody = jsonEncode({
        "mediaItemIds": photoIds,
      });

      var response = await authClient.post(
        Uri.parse(
            'https://photoslibrary.googleapis.com/v1/albums/$albumId:batchAddMediaItems'),
        body: jsonBody,
      );

      if (response.statusCode != 200) {
        _logger.warning(response.body);
        completer.completeError('Failed to add mediaItems to album');
      } else {
        _logger.info("Successfully added photo to album");
        completer.complete();
      }
    }).catchError((error) {
      _logger.warning('Error adding mediaItems to album: $error');
      completer.completeError('Error adding mediaItems to album');
    });

    return completer.future;
  }

  // Return all the albumIds from Google Photos
  Future<List<String>> getAlbumIds() async {
    AuthClient authClient = await getAuthClient();
    var response = await authClient.get(
      Uri.parse('https://photoslibrary.googleapis.com/v1/albums'),
    );

    if (response.statusCode != 200) {
      _logger.warning('Failed to get albums: ${response.statusCode}');
    }

    var data = jsonDecode(response.body);
    var albums = data['albums'] as List;
    var albumIds = albums.map((album) => album['id'] as String).toList();

    return albumIds;
  }

  // Returns all the albumNames from Google Photos
  Future<List<String>> getAlbumNames() async {
    AuthClient authClient = await getAuthClient();
    var response = await authClient.get(
      Uri.parse('https://photoslibrary.googleapis.com/v1/albums'),
    );

    if (response.statusCode != 200) {
      _logger.warning('Failed to get albums: ${response.statusCode}');
    }

    var data = jsonDecode(response.body);
    var albums = data['albums'] as List;
    var albumNames = albums.map((album) => album['title'] as String).toList();

    return albumNames;
  }

  // Maps albumNames and albumIds
  // Used inside the unsorted_image_gallery widget
  Future<Map<String, String>> getAlbumData() async {
    final albumNames = getAlbumNames();
    final albumIds = getAlbumIds();

    Map<String, String> albumDataMap =
        _dataMapper.combineListsToMap(await albumNames, await albumIds);

    return albumDataMap;
  }
}
