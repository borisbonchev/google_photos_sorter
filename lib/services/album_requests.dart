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
}
