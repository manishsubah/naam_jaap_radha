import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/utils/date_keys.dart';
import 'models/app_settings.dart';
import 'models/jaap_entry.dart';
import 'models/naam.dart';
import 'models/thought.dart';
import 'repositories/repositories.dart';

const _uuid = Uuid();

Never _notConfigured(String name) =>
    throw UnimplementedError('$name must be overridden in ProviderScope');

final naamRepositoryProvider = Provider<NaamRepository>((_) => _notConfigured('naamRepositoryProvider'));
final jaapRepositoryProvider = Provider<JaapRepository>((_) => _notConfigured('jaapRepositoryProvider'));
final thoughtRepositoryProvider =
    Provider<ThoughtRepository>((_) => _notConfigured('thoughtRepositoryProvider'));
final settingsRepositoryProvider =
    Provider<SettingsRepository>((_) => _notConfigured('settingsRepositoryProvider'));

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(settingsRepositoryProvider).load();

  Future<void> change(AppSettings Function(AppSettings current) update) async {
    state = update(state);
    await ref.read(settingsRepositoryProvider).save(state);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class NaamsNotifier extends Notifier<List<Naam>> {
  @override
  List<Naam> build() {
    final saved = ref.read(naamRepositoryProvider).getAll();
    return saved.isEmpty ? Naam.defaults : saved;
  }

  Future<Naam> add({required String name, String? script, String? greeting}) async {
    final trimmed = name.trim();
    final naam = Naam(
      id: _uuid.v4(),
      name: trimmed,
      script: (script?.trim().isNotEmpty ?? false) ? script!.trim() : trimmed,
      greeting: (greeting?.trim().isNotEmpty ?? false) ? greeting!.trim() : 'Jai $trimmed',
      isCustom: true,
    );
    state = [...state, naam];
    await ref.read(naamRepositoryProvider).save(naam);
    return naam;
  }

  Future<void> remove(String id) async {
    state = state.where((n) => n.id != id).toList();
    await ref.read(naamRepositoryProvider).delete(id);
    final settings = ref.read(settingsProvider);
    if (settings.selectedNaamId == id && state.isNotEmpty) {
      await ref.read(settingsProvider.notifier).change((s) => s.copyWith(selectedNaamId: state.first.id));
    }
  }
}

final naamsProvider = NotifierProvider<NaamsNotifier, List<Naam>>(NaamsNotifier.new);

final selectedNaamProvider = Provider<Naam>((ref) {
  final naams = ref.watch(naamsProvider);
  final id = ref.watch(settingsProvider.select((s) => s.selectedNaamId));
  return naams.where((n) => n.id == id).firstOrNull ?? naams.first;
});

final naamByIdProvider = Provider.family<Naam?, String>((ref, id) {
  return ref.watch(naamsProvider).where((n) => n.id == id).firstOrNull;
});

class JaapEntriesNotifier extends Notifier<List<JaapEntry>> {
  @override
  List<JaapEntry> build() => ref.read(jaapRepositoryProvider).getAll();

  Future<void> addCount(String naamId, int delta, {DateTime? date}) async {
    final key = dateKey(date ?? DateTime.now());
    final existing = state.where((e) => e.dateKey == key && e.naamId == naamId).firstOrNull;
    await setCount(key, naamId, (existing?.count ?? 0) + delta);
  }

  Future<void> setCount(String key, String naamId, int count) async {
    final id = JaapEntry.idFor(key, naamId);
    final repo = ref.read(jaapRepositoryProvider);
    final others = state.where((e) => e.id != id).toList();
    if (count <= 0) {
      state = others;
      await repo.delete(id);
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

class ThoughtsNotifier extends Notifier<List<Thought>> {
  @override
  List<Thought> build() => _sorted(ref.read(thoughtRepositoryProvider).getAll());

  static List<Thought> _sorted(List<Thought> list) =>
      [...list]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  String newId() => _uuid.v4();

  Future<void> save(Thought thought) async {
    final previous = state.where((t) => t.id == thought.id).firstOrNull;
    if (previous?.audioPath != null && previous!.audioPath != thought.audioPath) {
      await deleteAudioFile(previous.audioPath);
    }
    state = _sorted([...state.where((t) => t.id != thought.id), thought]);
    await ref.read(thoughtRepositoryProvider).save(thought);
  }

  Future<void> remove(String id) async {
    final thought = state.where((t) => t.id == id).firstOrNull;
    state = state.where((t) => t.id != id).toList();
    await ref.read(thoughtRepositoryProvider).delete(id);
    await deleteAudioFile(thought?.audioPath);
  }

  static Future<void> deleteAudioFile(String? path) async {
    if (path == null) return;
    final file = File(path);
    if (await file.exists()) await file.delete();
  }
}

final thoughtsProvider = NotifierProvider<ThoughtsNotifier, List<Thought>>(ThoughtsNotifier.new);
