import 'dart:convert';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:logging/logging.dart';

class PhotoService {
  final _scopes = ['https://www.googleapis.com/auth/photoslibrary'];
  final _clientId = ClientId(
      '672368799891-jbj743883luhl3qtp2qt8fsr0akdltv7.apps.googleusercontent.com',
      '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');
  final _logger = Logger('PhotoService');

  void prompt(String url) {
    print("Please go to the following URL and grant access:");
    print("  => $url");
    print("");
    launchUrlString(url);
  }

  Future<AuthClient> obtainAuthenticatedClient() async {
    final flow = await createImplicitBrowserFlow(
      _clientId,
      _scopes,
    );

    try {
      return await flow.clientViaUserConsent();
    } finally {
      flow.close();
    }
  }

  // #1 Return all photos from Google Photos
  // returnType: List<String> photoIds
  Future<List<String>> getAllPhotos() async {
    AuthClient authClient = await obtainAuthenticatedClient();
    var response = await authClient.get(
      Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems'),
    );

    if (response.statusCode != 200) {
      print('Failed to get photos: ${response.statusCode}');
      return [];
    }

    var data = jsonDecode(response.body);
    var photos = data['mediaItems'] as List;
    var photoIds = photos.map((photo) => photo['id'] as String).toList();

    // print(photoIds);
    return photoIds;
  }

  // #2 Return all the albumIds from Google Photos
  // returnType: List<String> albumIds
  Future<List<String>> getAlbumIds() async {
    AuthClient authClient = await obtainAuthenticatedClient();
    var response = await authClient.get(
      Uri.parse('https://photoslibrary.googleapis.com/v1/albums'),
    );

    if (response.statusCode != 200) {
      print('Failed to get albums: ${response.statusCode}');
      return [];
    }

    var data = jsonDecode(response.body);
    var albums = data['albums'] as List;
    var albumIds = albums.map((album) => album['id'] as String).toList();

    // print(albumIds);
    return albumIds;
  }

  // #3 Go through the albums and remember all the photos that already belong to them
  // For each album in the list of albums, if(photoId.exists(photoIdList))
  //                                         photoIdList.remove(photoId);
  // returnType: List<String> filteredPhotoIdList
  Future<List<String>> filterPhotoIds() async {
    AuthClient authClient = await obtainAuthenticatedClient();
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

      // Remove photoIds that exist in photoList
      photoList.removeWhere((photoId) => photoIds.contains(photoId));
      count++;
    }

    _logger.info('Filtered photoIds:');
    _logger.info(photoList);
    return photoList;
  }

  // Return all the image baseURLs from Google Photos
  Future<List<String>> returnAllImageUrls() async {
    AuthClient authClient = await obtainAuthenticatedClient();

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
