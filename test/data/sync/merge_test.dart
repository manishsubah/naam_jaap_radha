import 'package:flutter_test/flutter_test.dart';
import 'package:naam_jaap/data/models/jaap_entry.dart';
import 'package:naam_jaap/data/models/naam.dart';
import 'package:naam_jaap/data/sync/merge.dart';
import 'package:naam_jaap/data/sync/sync_snapshot.dart';

JaapEntry _e(String day, int count, int minute, {bool deleted = false}) => JaapEntry(
      dateKey: day,
      naamId: 'radha',
      count: count,
      updatedAt: DateTime.utc(2026, 10, 1, 0, minute),
      deleted: deleted,
    );

SyncSnapshot _s(List<JaapEntry> entries, [List<Naam> naams = const []]) =>
    SyncSnapshot(entries: entries, naams: naams);

void main() {
  test('first sync uploads everything local', () {
    final r = mergeSnapshots(_s([_e('2026-10-01', 108, 1)]), SyncSnapshot.empty);
    expect(r.remoteNeedsUpdate, isTrue);
    expect(r.changedEntries, isEmpty);
    expect(r.merged.entries.single.count, 108);
  });

  test('records only in the cloud are pulled down', () {
    final r = mergeSnapshots(SyncSnapshot.empty, _s([_e('2026-10-01', 108, 1)]));
    expect(r.changedEntries.single.count, 108);
    expect(r.remoteNeedsUpdate, isFalse);
  });

  test('newer edit wins in either direction', () {
    final older = _e('2026-10-01', 108, 1);
    final newer = _e('2026-10-01', 216, 2);

    final pull = mergeSnapshots(_s([older]), _s([newer]));
    expect(pull.changedEntries.single.count, 216);
    expect(pull.remoteNeedsUpdate, isFalse);

    final push = mergeSnapshots(_s([newer]), _s([older]));
    expect(push.changedEntries, isEmpty);
    expect(push.remoteNeedsUpdate, isTrue);
    expect(push.merged.entries.single.count, 216);
  });

  test('a newer deletion beats an older count', () {
    final r = mergeSnapshots(
      _s([_e('2026-10-01', 108, 1)]),
      _s([_e('2026-10-01', 0, 2, deleted: true)]),
    );
    expect(r.changedEntries.single.deleted, isTrue);
  });

  test('identical data needs no writes', () {
    final data = _s([_e('2026-10-01', 108, 1), _e('2026-10-02', 54, 3)]);
    final r = mergeSnapshots(data, data);
    expect(r.changedEntries, isEmpty);
    expect(r.remoteNeedsUpdate, isFalse);
  });

  test('custom naams merge by last edit', () {
    final local = Naam(id: 'n1', name: 'Shyam', script: 'श्याम', greeting: 'Jai', isCustom: true,
        updatedAt: DateTime.utc(2026, 10, 1));
    final removed = local.asDeleted(DateTime.utc(2026, 10, 2));
    final r = mergeSnapshots(_s([], [local]), _s([], [removed]));
    expect(r.changedNaams.single.deleted, isTrue);
  });

  test('snapshot survives a JSON round trip', () {
    final data = _s([_e('2026-10-01', 108, 1, deleted: true)]);
    final back = SyncSnapshot.fromJson(data.toJson());
    expect(back.entries.single.deleted, isTrue);
    expect(back.entries.single.updatedAt, data.entries.single.updatedAt);
  });

  test('refuses data from a newer schema', () {
    expect(
      () => SyncSnapshot.fromJson({'schemaVersion': SyncSnapshot.schemaVersion + 1}),
      throwsFormatException,
    );
  });
}
