import 'package:googleapis_auth/auth_browser.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AuthService {
  final _scopes = ['https://www.googleapis.com/auth/photoslibrary'];
  final _clientId = ClientId(
      '672368799891-jbj743883luhl3qtp2qt8fsr0akdltv7.apps.googleusercontent.com',
      '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');
  final _logger = Logger('AuthService');

  void prompt(String url) {
    _logger.info("Please go to the following URL and grant access:");
    _logger.info("  => $url");
    _logger.info("");
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
}
