import 'package:flutter_test/flutter_test.dart';
import 'package:naam_jaap/data/models/jaap_entry.dart';
import 'package:naam_jaap/data/sync/remote_store.dart';
import 'package:naam_jaap/data/sync/sync_service.dart';
import 'package:naam_jaap/data/sync/sync_snapshot.dart';

import '../../helpers/memory_repositories.dart';

class FakeRemote implements RemoteStore {
  SyncSnapshot? saved;
  int writes = 0;

  @override
  Future<SyncSnapshot?> read() async =>
      saved == null ? null : SyncSnapshot.fromJson(saved!.toJson());

  @override
  Future<void> write(SyncSnapshot snapshot) async {
    writes++;
    saved = snapshot;
  }
}

JaapEntry _e(String day, int count, int minute) => JaapEntry(
      dateKey: day,
      naamId: 'radha',
      count: count,
      updatedAt: DateTime.utc(2026, 10, 1, 0, minute),
    );

void main() {
  test('two devices converge through the cloud', () async {
    final cloud = FakeRemote();
    final phoneJaap = MemoryJaap([_e('2026-10-01', 108, 1)]);
    final tabletJaap = MemoryJaap([_e('2026-10-02', 54, 2)]);
    final phone = SyncService(naams: MemoryNaams(), jaap: phoneJaap);
    final tablet = SyncService(naams: MemoryNaams(), jaap: tabletJaap);

    expect(await phone.sync(cloud), isFalse);
    expect(await tablet.sync(cloud), isTrue);
    expect(await phone.sync(cloud), isTrue);

    expect(phoneJaap.items.keys.toSet(), tabletJaap.items.keys.toSet());
    expect(cloud.saved!.entries, hasLength(2));
  });

  test('a second sync with no changes does not upload', () async {
    final cloud = FakeRemote();
    final service = SyncService(naams: MemoryNaams(), jaap: MemoryJaap([_e('2026-10-01', 108, 1)]));
    await service.sync(cloud);
    await service.sync(cloud);
    expect(cloud.writes, 1);
  });

  test('built-in naams are not uploaded', () async {
    final cloud = FakeRemote();
    await SyncService(naams: MemoryNaams(), jaap: MemoryJaap()).sync(cloud);
    expect(cloud.saved!.naams, isEmpty);
  });
}
