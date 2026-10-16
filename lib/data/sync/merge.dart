import 'package:naam_jaap/data/models/jaap_entry.dart';
import 'package:naam_jaap/data/models/naam.dart';
import 'package:naam_jaap/data/sync/sync_snapshot.dart';

/// Result of merging this device's data with the copy in the cloud.
class MergeResult {
  const MergeResult({
    required this.merged,
    required this.changedEntries,
    required this.changedNaams,
    required this.remoteNeedsUpdate,
  });

  final SyncSnapshot merged;

  /// Records the cloud had that are newer than this device's; save them locally.
  final List<JaapEntry> changedEntries;
  final List<Naam> changedNaams;

  /// True when this device had something the cloud copy lacks.
  final bool remoteNeedsUpdate;
}

/// Merges record by record: for each id, the copy with the later `updatedAt`
/// wins, and a tombstone counts as a change like any other. On a tie the
/// local copy is kept. The merge is idempotent, so any device can re-run it
/// safely and every device ends up with the same data.
MergeResult mergeSnapshots(SyncSnapshot local, SyncSnapshot remote) {
  final entries = _mergeById<JaapEntry>(
    local.entries,
    remote.entries,
    id: (e) => e.id,
    updatedAt: (e) => e.updatedAt,
    same: (a, b) => a.count == b.count && a.deleted == b.deleted,
  );
  final naams = _mergeById<Naam>(
    local.naams,
    remote.naams,
    id: (n) => n.id,
    updatedAt: (n) => n.updatedAt ?? DateTime.utc(2000),
    same: (a, b) =>
        a.name == b.name && a.script == b.script && a.greeting == b.greeting && a.deleted == b.deleted,
  );
  return MergeResult(
    merged: SyncSnapshot(entries: entries.merged, naams: naams.merged),
    changedEntries: entries.fromRemote,
    changedNaams: naams.fromRemote,
    remoteNeedsUpdate: entries.remoteStale || naams.remoteStale,
  );
}

({List<T> merged, List<T> fromRemote, bool remoteStale}) _mergeById<T>(
  List<T> local,
  List<T> remote, {
  required String Function(T) id,
  required DateTime Function(T) updatedAt,
  required bool Function(T, T) same,
}) {
  final remoteById = {for (final r in remote) id(r): r};
  final merged = <String, T>{};
  final fromRemote = <T>[];
  var remoteStale = false;

  for (final l in local) {
    final r = remoteById.remove(id(l));
    if (r == null) {
      merged[id(l)] = l;
      remoteStale = true;
    } else if (updatedAt(r).isAfter(updatedAt(l))) {
      merged[id(l)] = r;
      if (!same(l, r)) fromRemote.add(r);
    } else {
      merged[id(l)] = l;
      if (updatedAt(l).isAfter(updatedAt(r)) || !same(l, r)) remoteStale = true;
    }
  }
  for (final r in remoteById.values) {
    merged[id(r)] = r;
    fromRemote.add(r);
  }
  return (merged: merged.values.toList(), fromRemote: fromRemote, remoteStale: remoteStale);
}
