import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' show DetailedApiRequestError;
import 'package:http/http.dart' as http;

import 'package:naam_jaap/core/config/google_oauth_config.dart';
import 'package:naam_jaap/data/providers/providers.dart';
import 'package:naam_jaap/data/sync/drive_remote_store.dart';
import 'package:naam_jaap/data/sync/google_account.dart';
import 'package:naam_jaap/data/sync/remote_store.dart';
import 'package:naam_jaap/data/sync/sync_service.dart';

enum SyncStatus {
  /// No Google client IDs in this build, so sign-in can't be offered.
  unavailable,
  signedOut,
  connecting,
  syncing,
  synced,

  /// Signed in before, but Google needs the user to approve access again.
  needsReconnect,
  error,
}

/// Why the last sync failed. The UI turns this into a message in the app's
/// language.
enum SyncError { signIn, driveUnreachable, unreadableBackup, unknown }

class SyncState {
  const SyncState(this.status, {this.email, this.lastSyncedAt, this.error});

  final SyncStatus status;
  final String? email;
  final DateTime? lastSyncedAt;
  final SyncError? error;

  bool get isSignedIn => email != null;

  SyncState copyWith({SyncStatus? status, DateTime? lastSyncedAt, SyncError? error}) => SyncState(
        status ?? this.status,
        email: email,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        error: error,
      );
}

/// Null when Google sign-in isn't configured for this build.
final cloudAccountProvider = Provider<CloudAccount?>((ref) {
  return GoogleOAuthConfig.isConfigured ? GoogleCloudAccount(DriveRemoteStore.scopes) : null;
});

final remoteStoreFactoryProvider = Provider<RemoteStore Function(http.Client client)>(
  (ref) => DriveRemoteStore.new,
);

/// Keeps local data in sync with the user's Google Drive app folder.
///
/// Syncs at launch, when the app returns to the foreground, a few seconds
/// after any change (so tapping beads doesn't upload on every tap), and on
/// demand.
class SyncController extends Notifier<SyncState> {
  static const debounce = Duration(seconds: 5);

  Timer? _timer;
  bool _running = false;
  bool _rerun = false;
  bool _applyingRemote = false;

  CloudAccount? get _account => ref.read(cloudAccountProvider);

  @override
  SyncState build() {
    if (ref.watch(cloudAccountProvider) == null) return const SyncState(SyncStatus.unavailable);

    ref.listen(jaapEntriesProvider, (_, _) => _onLocalChange());
    ref.listen(naamsProvider, (_, _) => _onLocalChange());
    final lifecycle = AppLifecycleListener(onResume: () => _schedule(Duration.zero));
    ref.onDispose(() {
      lifecycle.dispose();
      _timer?.cancel();
    });

    Future.microtask(_restore);
    return const SyncState(SyncStatus.signedOut);
  }

  Future<void> _restore() async {
    try {
      final email = await _account!.restore();
      if (email == null) return;
      state = SyncState(SyncStatus.syncing, email: email);
      await syncNow();
    } catch (_) {
      // Restoring is best effort; the user can still sign in from Settings.
    }
  }

  Future<void> signIn() async {
    final account = _account;
    if (account == null) return;
    state = SyncState(SyncStatus.connecting, email: state.email);
    try {
      final email = await account.signIn();
      state = SyncState(SyncStatus.syncing, email: email);
      await syncNow(interactive: true);
    } on GoogleSignInException catch (e) {
      final canceled = e.code == GoogleSignInExceptionCode.canceled;
      state = SyncState(
        canceled ? SyncStatus.signedOut : SyncStatus.error,
        error: canceled ? null : SyncError.signIn,
      );
    } catch (_) {
      state = const SyncState(SyncStatus.error, error: SyncError.signIn);
    }
  }

  Future<void> signOut() async {
    _timer?.cancel();
    await _account?.signOut();
    state = const SyncState(SyncStatus.signedOut);
  }

  void _onLocalChange() {
    if (!_applyingRemote) _schedule(debounce);
  }

  void _schedule(Duration delay) {
    if (!state.isSignedIn || state.status == SyncStatus.needsReconnect) return;
    _timer?.cancel();
    _timer = Timer(delay, syncNow);
  }

  Future<void> syncNow({bool interactive = false}) async {
    final account = _account;
    if (account == null || !state.isSignedIn) return;
    if (_running) {
      _rerun = true;
      return;
    }
    _running = true;
    state = state.copyWith(status: SyncStatus.syncing);
    try {
      final client = await account.client(interactive: interactive);
      if (client == null) {
        state = state.copyWith(status: SyncStatus.needsReconnect);
        return;
      }
      try {
        final service = SyncService(
          naams: ref.read(naamRepositoryProvider),
          jaap: ref.read(jaapRepositoryProvider),
        );
        final changed = await service.sync(ref.read(remoteStoreFactoryProvider)(client));
        if (changed) _reloadLocal();
      } finally {
        client.close();
      }
      state = state.copyWith(status: SyncStatus.synced, lastSyncedAt: DateTime.now());
    } on DetailedApiRequestError catch (e) {
      state = e.status == 401 || e.status == 403
          ? state.copyWith(status: SyncStatus.needsReconnect)
          : state.copyWith(status: SyncStatus.error, error: SyncError.driveUnreachable);
    } on FormatException {
      state = state.copyWith(status: SyncStatus.error, error: SyncError.unreadableBackup);
    } catch (_) {
      state = state.copyWith(
        status: SyncStatus.error,
        error: SyncError.unknown,
      );
    } finally {
      _running = false;
      if (_rerun) {
        _rerun = false;
        _schedule(Duration.zero);
      }
    }
  }

  void _reloadLocal() {
    _applyingRemote = true;
    try {
      ref.read(naamsProvider.notifier).reload();
      ref.read(jaapEntriesProvider.notifier).reload();
    } finally {
      _applyingRemote = false;
    }
  }
}

final syncControllerProvider = NotifierProvider<SyncController, SyncState>(SyncController.new);
