// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:html';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:google_photos_test/services/album_requests.dart';
import 'package:google_photos_test/services/authentication.dart';
import 'package:google_photos_test/services/data_mapper.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:logging/logging.dart';

class PhotoRequests {
  final AuthService _authService = AuthService();
  final AlbumRequests _albumService = AlbumRequests();
  final DataMapper _dataMapper = DataMapper();
  final _logger = Logger('PhotoRequests');

  Future<AuthClient> getAuthClient() async {
    return await _authService.obtainAuthenticatedClient();
  }

  // Return all photos from Google Photos / Gallery Page
  // returnType: List of photo Ids
  Future<List<String>> getAllPhotos() async {
    AuthClient authClient = await getAuthClient();
    var response = await authClient.get(
      Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems'),
    );

    if (response.statusCode != 200) {
      _logger.warning('Failed to get photos: ${response.statusCode}');
    }

    var data = jsonDecode(response.body);
    var photos = data['mediaItems'] as List;
    var photoIds = photos.map((photo) => photo['id'] as String).toList();

    return photoIds;
  }

  // Gets all photos => Gets all photos that belong inside an album using a loop
  // => filters out photos that are in albums => returns image Urls and Ids
  // return: Map of imageUrls and corresponding imageIds
  Future<Map<String, String>> filterPhotos() async {
    AuthClient authClient = await getAuthClient();
    List<String> photoList = await getAllPhotos();
    List<String> albumList = await _albumService.getAlbumIds();

    if (albumList.isEmpty) {
      var response = await authClient.get(
        Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems'),
      );

      var data = jsonDecode(response.body);
      var photos = data['mediaItems'] as List;
      photoList = photos.map((photo) => photo['id'] as String).toList();
    } else {
      for (String albumId in albumList) {
        String jsonBody = jsonEncode({
          "albumId": albumId,
          "pageSize": 100,
        });

        var response = await authClient.post(
          Uri.parse(
              'https://photoslibrary.googleapis.com/v1/mediaItems:search'),
          body: jsonBody,
        );

        if (response.statusCode != 200) {
          _logger.warning('Failed to get albums: ${response.statusCode}');
        }

        var data = jsonDecode(response.body);
        if (data['mediaItems'] == null) {
          _logger.info('No media items found in the album: $albumId');
          continue;
        }

        var photos = data['mediaItems'] as List;
        var photosInAlbum =
            photos.map((photo) => photo['id'] as String).toList();

        // Removing photosInAlbum that exist in photoList
        // return: photoList with photos that are not in any album
        photoList.removeWhere((photoId) => photosInAlbum.contains(photoId));
      }
    }
    Future<List<String>> photoUrls = returnImageUrls(photoList);

    // Mapping imageUrls to imageIds
    Map<String, String> imageUrlToIdMap =
        _dataMapper.combineListsToMap(await photoUrls, photoList);

    return imageUrlToIdMap;
  }

  // USED FOR PRINTING IMAGES IN GALLERY // NO AUTHORIZATION NEEDED
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
      }

      return filteredUrls;
    } else {
      _logger.warning('Failed with status code: ${tokenResult.statusCode}');
      throw Exception('Failed to fetch image URLs');
    }
  }

  //
  Future<List<String>> returnFilteredGooglePhotosUrlAuthorized() async {
    AuthClient authClient = await getAuthClient();
    List<String> photoList = await getAllPhotos();
    List<String> albumList = await _albumService.getAlbumIds();

    if (albumList.isEmpty) {
      var response = await authClient.get(
        Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems'),
      );

      var data = jsonDecode(response.body);
      var photos = data['mediaItems'] as List;
      photoList = photos.map((photo) => photo['id'] as String).toList();
    } else {
      for (String albumId in albumList) {
        String jsonBody = jsonEncode({
          "albumId": albumId,
          "pageSize": 100,
        });

        var response = await authClient.post(
          Uri.parse(
              'https://photoslibrary.googleapis.com/v1/mediaItems:search'),
          body: jsonBody,
        );

        if (response.statusCode != 200) {
          _logger.warning('Failed to get albums: ${response.statusCode}');
        }

        var data = jsonDecode(response.body);
        if (data['mediaItems'] == null) {
          _logger.info('No media items found in the album: $albumId');
          continue;
        }

        var photos = data['mediaItems'] as List<dynamic>;
        var photoIds = photos.map((photo) => photo['id'] as String).toList();

        // Removing photoIds that exist in photoList
        photoList.removeWhere((photoId) => photoIds.contains(photoId));
      }
    }
    Future<List<String>> googlePhotosUrl = returnImagePhotosUrl(photoList);

    return googlePhotosUrl;
  }

  // USED FOR REDIRECTING THE USER TO GOOGLE PHOTOS // AUTHORIZED ONLY
  Future<List<String>> returnImagePhotosUrl(List<String> imageIds) async {
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
          filteredUrls.add(photo['productUrl']);
        }
      }

      if (filteredUrls.isEmpty) {
        _logger.warning('No images found with provided IDs');
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

      return filterByBaseUrl.cast<String>();
    } else {
      _logger.warning('Failed with status code: ${tokenResult.statusCode}');
      throw Exception('Failed to fetch image URLs');
    }
  }

  // Used for uploading images to Google Photos from local assets
  // Dev Page: Upload Photos
  Future<void> uploadImage(String imagePath) async {
    AuthClient authClient = await getAuthClient();
    final Uint8List imageBytes = await loadImageBytes(imagePath);

    var uploadToken = await authClient.post(
      Uri.parse('https://photoslibrary.googleapis.com/v1/uploads'),
      headers: {
        'Content-type': 'application/octet-stream',
        'X-Goog-Upload-Content-Type': 'image/jpeg',
        'X-Goog-Upload-Protocol': 'raw'
      },
      body: imageBytes,
    );

    var res = await authClient.post(
      Uri.parse(
          'https://photoslibrary.googleapis.com/v1/mediaItems:batchCreate'),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({
        "newMediaItems": [
          {
            "description": "item-description",
            "simpleMediaItem": {
              "fileName": "flutter-photos-upload",
              "uploadToken": uploadToken.body,
            }
          }
        ]
      }),
    );

    if (res.statusCode == 200) {
      _logger.info('Image uploaded successfully');
    } else {
      _logger.warning('Failed to upload image: ${res.statusCode}');
    }
  }

  // Returns the image as bytes
  Future<Uint8List> loadImageBytes(String imagePath) async {
    final ByteData data = await rootBundle.load(imagePath);
    return data.buffer.asUint8List();
  }

  // NOT WORKING: Authentication error?
  // Uploading images to Google Photos using File Picker
  Future<void> uploadToGooglePhotos(File file) async {
    AuthClient authClient = await getAuthClient();

    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);

    await reader.onLoad.first;

    final nativeUint8List = reader.result as Uint8List;

    final imageBytes = Uint8List.fromList(nativeUint8List);

    var uploadToken = await authClient.post(
      Uri.parse('https://photoslibrary.googleapis.com/v1/uploads'),
      headers: {
        'Content-type': 'application/octet-stream',
        'X-Goog-Upload-Content-Type': 'image/jpeg',
        'X-Goog-Upload-Protocol': 'raw'
      },
      body: imageBytes,
    );

    // ignore: unused_local_variable
    var res = await authClient.post(
      Uri.parse(
          'https://photoslibrary.googleapis.com/v1/mediaItems:batchCreate'),
      headers: {
        'Content-type': 'application/json',
      },
      body: jsonEncode({
        "newMediaItems": [
          {
            "description": "item-description",
            "simpleMediaItem": {
              "fileName": "flutter-photos-upload",
              "uploadToken": uploadToken.body,
            }
          }
        ]
      }),
    );

    if (res.statusCode == 200) {
      _logger.info('Image uploaded successfully');
    } else {
      _logger.warning('Failed to upload image: ${res.statusCode}');
    }
  }
}
