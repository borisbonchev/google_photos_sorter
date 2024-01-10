// ignore: avoid_web_libraries_in_flutter
// ignore_for_file: deprecated_member_use
import 'package:googleapis_auth/auth_browser.dart';

class AuthService {
  final _scopes = ['https://www.googleapis.com/auth/photoslibrary'];
  final authorizationEndpoint =
      Uri.parse('https://accounts.google.com/o/oauth2/v2/auth');
  final tokenEndpoint = Uri.parse('https://oauth2.googleapis.com/token');
  final _identifier =
      '672368799891-jbj743883luhl3qtp2qt8fsr0akdltv7.apps.googleusercontent.com';
  final _secret = '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';
  late final ClientId _clientId;
  AuthClient? _cachedAuthClient;

  AuthService() {
    _clientId = ClientId(_identifier, _secret);
  }

  Future<AuthClient> obtainAuthenticatedClient() async {
    if (_cachedAuthClient != null) {
      return _cachedAuthClient!;
    }

    final flow = await createImplicitBrowserFlow(
      _clientId,
      _scopes,
    );

    try {
      _cachedAuthClient = await flow.clientViaUserConsent();
      return _cachedAuthClient!;
    } finally {
      flow.close();
    }
  }

//   ?NOT USING THIS ANYMORE BUT MIGHT NEED IT LATER?
//
//   Map<String, String> getQueryParams(String url) {
//     final Uri uri = Uri.parse(url);
//     return uri.queryParameters;
//   }

// // Simulate the process of obtaining the authorization code
//   String obtainAuthorizationCode() {
//     final queryParams = getQueryParams(html.window.location.href);
//     return queryParams['code'] ?? ''; // Extract the 'code' parameter from URL
//   }

//   Future<Credentials> obtainCredentials() async {
//     final grant = AuthorizationCodeGrant(
//       _identifier,
//       authorizationEndpoint,
//       tokenEndpoint,
//       secret: _secret,
//     );

//     final authorizationUrl = grant.getAuthorizationUrl(
//       Uri.parse('http://localhost:8080/callback'),
//       scopes: _scopes,
//     );

//     // Redirect the user to authorizationUrl (this depends on your UI/UX implementation)
//     html.window.location.assign(authorizationUrl.toString());

//     // Simulating authorization code received after user grants access (replace this with your actual logic)
//     final authorizationCode = obtainAuthorizationCode();

//     // Use the obtained authorization code to get the access token
//     final client =
//         await grant.handleAuthorizationResponse({'code': authorizationCode});
//     final accessToken = client.credentials;

//     return accessToken;
//   }
}
