import 'dart:convert';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:googleapis_auth/auth_browser.dart';

class PhotoService {
  final _scopes = ['https://www.googleapis.com/auth/photoslibrary'];
  final clientId =
      '672368799891-jbj743883luhl3qtp2qt8fsr0akdltv7.apps.googleusercontent.com';

  void prompt(String url) {
    print("Please go to the following URL and grant access:");
    print("  => $url");
    print("");
    launchUrlString(url);
  }

  Future<AuthClient> obtainAuthenticatedClient() async {
    final flow = await createImplicitBrowserFlow(
      ClientId(clientId),
      _scopes,
    );

    try {
      return await flow.clientViaUserConsent();
    } finally {
      flow.close();
    }
  }

  // Future<AuthClient> authenticate() async {
  //   return await clientViaUserConsent(ClientId(clientId), _scopes, prompt);
  // }

  pictureSearch() async {
    AuthClient authClient = await obtainAuthenticatedClient();

    var requestBody = jsonEncode({
      "albumId":
          "AEHElZz2e8qtd1zMwZtzy2iZQzLBkbrLcgmoXEuOVbrSSmPGEA8Fluua0BNde8wYyo9ZpCC_lK77",
    });

    var tokenResult = await authClient.post(
        Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems:search'),
        body: requestBody);

    if (tokenResult.statusCode != 200) {
      print('Failed to get upload token: ${tokenResult.statusCode}');
      return;
    }

    print("Success");
    print("");
    print(tokenResult.body);

    String jsonResponse = tokenResult.body;
    Map<String, dynamic> data = jsonDecode(jsonResponse);
    List<dynamic> filterByFilename = (data['mediaItems'] as List<dynamic>)
        .map((photo) => photo['filename'])
        .toList();

    List<dynamic> filterByNoAlbum = (data['mediaItems'] as List<dynamic>)
        .map((photo) => photo['filename'])
        .toList();

    print(filterByFilename);

    var albumIds = await getAlbumIds();
    print(albumIds);
  }

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

    print(albumIds);
    return albumIds;
  }

  getAlbumById() async {
    String albumId =
        "AEHElZz2e8qtd1zMwZtzy2iZQzLBkbrLcgmoXEuOVbrSSmPGEA8Fluua0BNde8wYyo9ZpCC_lK77";
    AuthClient authClient = await obtainAuthenticatedClient();
    var response = await authClient.get(
      Uri.parse('https://photoslibrary.googleapis.com/v1/albums'),
    );

    if (response.statusCode != 200) {
      print('Failed to get albums: ${response.statusCode}');
      return [];
    }

    print(response.body);
  }

  Future<void> searchMediaItems() async {
    AuthClient authClient = await obtainAuthenticatedClient();
    var requestBody = jsonEncode({
      'pageSize': '100',
      'albumId':
          "AEHElZz6XH763_yIefG6hvxcEpGemuuYNItkcHxI9pmXcW_IxiVvfD0QwEDzmJgluD-NQpQTWA9j",
    });

    var tokenResult = await authClient.post(
        Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems:search'),
        body: requestBody);

    if (tokenResult.statusCode == 200) {
      String jsonResponse = tokenResult.body;
      Map<String, dynamic> data = jsonDecode(jsonResponse);
      List<dynamic> filenames = (data['mediaItems'] as List<dynamic>)
          .map((photo) => photo['filename'])
          .toList();

      print(filenames);
    } else {
      print('Failed with status code: ${tokenResult.statusCode}');
    }
  }

  Future<List<String>> returnImgUrls() async {
    AuthClient authClient = await obtainAuthenticatedClient();
    var requestBody = jsonEncode({
      'pageSize': '100',
      'albumId':
          "AEHElZz6XH763_yIefG6hvxcEpGemuuYNItkcHxI9pmXcW_IxiVvfD0QwEDzmJgluD-NQpQTWA9j",
    });

    var tokenResult = await authClient.post(
        Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems:search'),
        body: requestBody);

    if (tokenResult.statusCode == 200) {
      String jsonResponse = tokenResult.body;
      Map<String, dynamic> data = jsonDecode(jsonResponse);
      List<String> imageUrls = (data['mediaItems'] as List<dynamic>)
          .map((photo) => photo['baseUrl'] as String)
          .toList();

      print(imageUrls);
      return imageUrls;
    } else {
      print('Failed to get media items: ${tokenResult.statusCode}');
      return [];
    }
  }

  getImageById(String id) async {
    AuthClient authClient = await obtainAuthenticatedClient();

    var tokenResult = await authClient.get(
      Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems/$id')
    );

    print(tokenResult.body);
  }
}
