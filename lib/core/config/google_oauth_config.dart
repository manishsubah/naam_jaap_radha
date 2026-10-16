import 'dart:io';

/// Google OAuth client IDs, passed at build time so they never live in code:
///
///   flutter run --dart-define-from-file=config/google_oauth.json
///
/// See docs/google_backup_setup.md for how to create them.
abstract final class GoogleOAuthConfig {
  /// iOS OAuth client ID (…apps.googleusercontent.com).
  static const iosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');

  /// Web OAuth client ID. Android needs it to request Google sign-in.
  static const serverClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

  static bool get isConfigured {
    if (Platform.isIOS) return iosClientId.isNotEmpty;
    if (Platform.isAndroid) return serverClientId.isNotEmpty;
    return false;
  }
}
