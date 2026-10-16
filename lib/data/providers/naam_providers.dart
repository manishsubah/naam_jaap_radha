import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:naam_jaap/data/models/naam.dart';
import 'package:naam_jaap/data/providers/repository_providers.dart';
import 'package:naam_jaap/data/providers/settings_provider.dart';

const _uuid = Uuid();

class NaamsNotifier extends Notifier<List<Naam>> {
  @override
  List<Naam> build() => Naam.ordered(ref.read(naamRepositoryProvider).getAll());

  /// Re-reads naams from storage, after a sync has written merged data.
  void reload() => state = build();

  Future<Naam> add({required String name, String? script, String? greeting}) async {
    final trimmed = name.trim();
    final naam = Naam(
      id: _uuid.v4(),
      name: trimmed,
      script: (script?.trim().isNotEmpty ?? false) ? script!.trim() : trimmed,
      greeting: (greeting?.trim().isNotEmpty ?? false) ? greeting!.trim() : 'Jai $trimmed',
      isCustom: true,
      updatedAt: DateTime.now(),
    );
    state = [...state, naam];
    await ref.read(naamRepositoryProvider).save(naam);
    return naam;
  }

  Future<void> remove(String id) async {
    final naam = state.where((n) => n.id == id).firstOrNull;
    if (naam == null) return;
    state = state.where((n) => n.id != id).toList();
    await ref.read(naamRepositoryProvider).save(naam.asDeleted(DateTime.now()));
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
