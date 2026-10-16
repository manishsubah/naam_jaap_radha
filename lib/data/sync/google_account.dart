import 'dart:io';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:naam_jaap/core/config/google_oauth_config.dart';

/// The signed-in Google account that holds the user's synced data.
abstract interface class CloudAccount {
  /// Restores an earlier sign-in without showing UI; the email, or null.
  Future<String?> restore();

  /// Interactive sign-in plus permission for app data; returns the email.
  Future<String> signIn();

  Future<void> signOut();

  /// An authorized HTTP client, or null if the user must sign in again.
  /// With [interactive], the permission prompt may be shown.
  Future<http.Client?> client({bool interactive = false});
}

class GoogleCloudAccount implements CloudAccount {
  GoogleCloudAccount(this.scopes);

  final List<String> scopes;
  final _signIn = GoogleSignIn.instance;
  Future<void>? _initialized;
  GoogleSignInAccount? _account;

  Future<void> _init() => _initialized ??= _signIn.initialize(
        clientId: Platform.isIOS ? GoogleOAuthConfig.iosClientId : null,
        serverClientId:
            GoogleOAuthConfig.serverClientId.isEmpty ? null : GoogleOAuthConfig.serverClientId,
      );

  @override
  Future<String?> restore() async {
    await _init();
    _account = await (_signIn.attemptLightweightAuthentication() ?? Future.value());
    return _account?.email;
  }

  @override
  Future<String> signIn() async {
    await _init();
    final account = await _signIn.authenticate(scopeHint: scopes);
    await account.authorizationClient.authorizeScopes(scopes);
    _account = account;
    return account.email;
  }

  @override
  Future<void> signOut() async {
    await _init();
    _account = null;
    await _signIn.signOut();
  }

  @override
  Future<http.Client?> client({bool interactive = false}) async {
    final account = _account;
    if (account == null) return null;
    final auth = account.authorizationClient;
    final authorization = await auth.authorizationForScopes(scopes) ??
        (interactive ? await auth.authorizeScopes(scopes) : null);
    return authorization?.authClient(scopes: scopes);
  }
}
