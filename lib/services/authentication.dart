import 'package:googleapis_auth/auth_browser.dart';

class AuthService {
  final _scopes = ['https://www.googleapis.com/auth/photoslibrary'];
  final _clientId = ClientId(
    '672368799891-jbj743883luhl3qtp2qt8fsr0akdltv7.apps.googleusercontent.com',
    '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',
  );
  AuthClient? _cachedAuthClient; // Cache the authenticated client

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
}
