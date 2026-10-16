import 'package:naam_jaap/data/sync/sync_snapshot.dart';

/// Where the synced copy of the user's data lives.
abstract interface class RemoteStore {
  /// The saved snapshot, or null if nothing has been saved yet.
  Future<SyncSnapshot?> read();

  Future<void> write(SyncSnapshot snapshot);
}
