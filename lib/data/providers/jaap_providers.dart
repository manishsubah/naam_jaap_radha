import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:naam_jaap/core/utils/date_keys.dart';
import 'package:naam_jaap/data/models/jaap_entry.dart';
import 'package:naam_jaap/data/providers/repository_providers.dart';

class JaapEntriesNotifier extends Notifier<List<JaapEntry>> {
  @override
  List<JaapEntry> build() =>
      ref.read(jaapRepositoryProvider).getAll().where((e) => !e.deleted).toList();

  /// Re-reads entries from storage, after a sync has written merged data.
  void reload() => state = build();

  JaapEntry? entryFor(String key, String naamId) =>
      state.where((e) => e.dateKey == key && e.naamId == naamId).firstOrNull;

  Future<void> addCount(String naamId, int delta, {DateTime? date}) async {
    final key = dateKey(date ?? DateTime.now());
    await setCount(key, naamId, (entryFor(key, naamId)?.count ?? 0) + delta);
  }

  /// Sets the exact count for a day and naam. A count of zero or less removes
  /// the record (stored as a tombstone so the removal syncs).
  Future<void> setCount(String key, String naamId, int count) async {
    final id = JaapEntry.idFor(key, naamId);
    final repo = ref.read(jaapRepositoryProvider);
    final others = state.where((e) => e.id != id).toList();
    final existed = others.length != state.length;
    if (count <= 0) {
      state = others;
      if (existed) {
        await repo.save(JaapEntry(
          dateKey: key,
          naamId: naamId,
          count: 0,
          updatedAt: DateTime.now(),
          deleted: true,
        ));
      }
      return;
    }
    final entry = JaapEntry(dateKey: key, naamId: naamId, count: count, updatedAt: DateTime.now());
    state = [...others, entry];
    await repo.save(entry);
  }
}

final jaapEntriesProvider =
    NotifierProvider<JaapEntriesNotifier, List<JaapEntry>>(JaapEntriesNotifier.new);

final dailyTotalsProvider = Provider<Map<String, int>>((ref) {
  final totals = <String, int>{};
  for (final e in ref.watch(jaapEntriesProvider)) {
    totals[e.dateKey] = (totals[e.dateKey] ?? 0) + e.count;
  }
  return totals;
});

final naamTotalsProvider = Provider<Map<String, int>>((ref) {
  final totals = <String, int>{};
  for (final e in ref.watch(jaapEntriesProvider)) {
    totals[e.naamId] = (totals[e.naamId] ?? 0) + e.count;
  }
  return totals;
});

final todayTotalProvider = Provider<int>((ref) {
  return ref.watch(dailyTotalsProvider)[dateKey(DateTime.now())] ?? 0;
});

final todayCountForNaamProvider = Provider.family<int, String>((ref, naamId) {
  final key = dateKey(DateTime.now());
  return ref
          .watch(jaapEntriesProvider)
          .where((e) => e.dateKey == key && e.naamId == naamId)
          .firstOrNull
          ?.count ??
      0;
});

final lifetimeTotalProvider = Provider<int>((ref) {
  return ref.watch(dailyTotalsProvider).values.fold(0, (a, b) => a + b);
});

final streakProvider = Provider<int>((ref) {
  return computeStreak(ref.watch(dailyTotalsProvider), DateTime.now());
});
