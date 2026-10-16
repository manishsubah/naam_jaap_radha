import 'package:naam_jaap/data/repositories/repositories.dart';
import 'package:naam_jaap/data/sync/merge.dart';
import 'package:naam_jaap/data/sync/remote_store.dart';
import 'package:naam_jaap/data/sync/sync_snapshot.dart';

/// One sync pass: read the cloud copy, merge it with local data, save what
/// the cloud had that's newer, and upload if the cloud is missing anything.
///
/// Read-merge-write means two devices syncing at the same instant could
/// overwrite each other's upload, but each keeps its own records locally and
/// re-uploads them on its next sync, so nothing is lost.
class SyncService {
  const SyncService({required this.naams, required this.jaap});

  final NaamRepository naams;
  final JaapRepository jaap;

  /// Returns true if local data changed.
  Future<bool> sync(RemoteStore remote) async {
    final local = SyncSnapshot(
      entries: jaap.getAll(),
      naams: naams.getAll().where((n) => n.isCustom).toList(),
    );
    final cloud = await remote.read();
    final result = mergeSnapshots(local, cloud ?? SyncSnapshot.empty);

    if (result.changedNaams.isNotEmpty) await naams.saveAll(result.changedNaams);
    if (result.changedEntries.isNotEmpty) await jaap.saveAll(result.changedEntries);
    if (cloud == null || result.remoteNeedsUpdate) await remote.write(result.merged);

    return result.changedNaams.isNotEmpty || result.changedEntries.isNotEmpty;
  }
}
