import 'dart:convert';

import 'package:google_photos_test/services/authentication.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:logging/logging.dart';

class PhotoRequests {
  final AuthService _authService = AuthService();
  final _logger = Logger('PhotoRequests');

  Future<AuthClient> getAuthClient() async {
    return await _authService.obtainAuthenticatedClient();
  }

  // Return all photos from Google Photos
  // returnType: List<String> photoIds
  Future<List<String>> getAllPhotos() async {
    AuthClient authClient = await getAuthClient();
    var response = await authClient.get(
      Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems'),
    );

    if (response.statusCode != 200) {
      _logger.warning('Failed to get photos: ${response.statusCode}');
      return [];
    }

    var data = jsonDecode(response.body);
    var photos = data['mediaItems'] as List;
    var photoIds = photos.map((photo) => photo['id'] as String).toList();

    // print(photoIds);
    return photoIds;
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

    // print(albumIds);
    return albumIds;
  }

  // Takes all photos => filters out photos that are in albums => returns imageUrls
  // return: Filtered iamgeUrls of photos that are not in any album
  Future<List<String>> filterPhotos() async {
    AuthClient authClient = await getAuthClient();
    List<String> photoList = await getAllPhotos();
    List<String> albumList = await getAlbumIds();

    int count = 1;
    for (String albumId in albumList) {
      String jsonBody = jsonEncode({
        "albumId": albumId,
        "pageSize": 100,
      });

      var response = await authClient.post(
          Uri.parse(
              'https://photoslibrary.googleapis.com/v1/mediaItems:search'),
          body: jsonBody);

      if (response.statusCode != 200) {
        _logger.warning('Failed to get albums: ${response.statusCode}');
      }

      var data = jsonDecode(response.body);
      var photos = data['mediaItems'] as List;
      var photoIds = photos.map((photo) => photo['id'] as String).toList();

      _logger.info('Album $count');
      _logger.info('PhotoIds:');
      _logger.info(photoIds);

      // Removing photoIds that exist in photoList
      photoList.removeWhere((photoId) => photoIds.contains(photoId));
      count++;
    }

    _logger.info('Filtered photoIds:');
    _logger.info(photoList);
    return returnImageUrls(photoList);
  }

  // Return the baseUrls of photos based on a list of imageIds
  // return: List of urls of images
  Future<List<String>> returnImageUrls(List<String> imageIds) async {
    AuthClient authClient = await getAuthClient();

    var tokenResult = await authClient.post(
        Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems:search'));

    if (tokenResult.statusCode == 200) {
      String jsonResponse = tokenResult.body;
      Map<String, dynamic> data = jsonDecode(jsonResponse);
      List<String> filteredUrls = [];

      // Filtering based on image IDs
      List<dynamic> mediaItems = data['mediaItems'] as List<dynamic>;
      for (var photo in mediaItems) {
        if (imageIds.contains(photo['id'])) {
          filteredUrls.add(photo['baseUrl']);
        }
      }

      if (filteredUrls.isEmpty) {
        _logger.warning('No images found with provided IDs');
      } else {
        _logger.info('BaseUrls of filtered images:');
        _logger.info(filteredUrls);
      }

      return filteredUrls;
    } else {
      _logger.warning('Failed with status code: ${tokenResult.statusCode}');
      throw Exception('Failed to fetch image URLs');
    }
  }

  // Used in Gallery: Returns the baseUrls of all photos
  Future<List<String>> returnAllImageUrls() async {
    AuthClient authClient = await getAuthClient();

    var tokenResult = await authClient.post(
        Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems:search'));

    if (tokenResult.statusCode == 200) {
      String jsonResponse = tokenResult.body;
      Map<String, dynamic> data = jsonDecode(jsonResponse);
      List<dynamic> filterByBaseUrl = (data['mediaItems'] as List<dynamic>)
          .map((photo) => photo['baseUrl'])
          .toList();

      _logger.info("BaseUrls of all images:");
      _logger.info(filterByBaseUrl);
      return filterByBaseUrl.cast<String>();
    } else {
      _logger.warning('Failed with status code: ${tokenResult.statusCode}');
      throw Exception('Failed to fetch image URLs');
    }
  }
}
