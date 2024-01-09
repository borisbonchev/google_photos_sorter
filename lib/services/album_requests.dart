import 'dart:convert';

import 'package:google_photos_test/services/authentication.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:logging/logging.dart';

class AlbumRequests {
  final AuthService _authService = AuthService();
  final _logger = Logger('AlbumRequests');

  Future<AuthClient> getAuthClient() async {
    return await _authService.obtainAuthenticatedClient();
  }

  // Creates an empty album in Google Photos
  Future<String> createAlbum(String name) async {
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
      return response.body;
    } else {
      throw Exception('Failed to create album: ${response.statusCode}');
    }
  }

  // Adds a list of photos to an album
  Future<String> addPhotosToAlbum(
      String albumId, List<String> mediaItemIds) async {
    AuthClient authClient = await getAuthClient();

    var response = await authClient.post(
      Uri.parse(
          'https://photoslibrary.googleapis.com/v1/albums/$albumId:batchAddMediaItems'),
      body: jsonEncode({
        'mediaItemIds': mediaItemIds,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
          'Failed to add mediaItems to album: ${response.statusCode}');
    }
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

    _logger.info("Album names: \n$albumNames");
    return albumNames;
  }
}
