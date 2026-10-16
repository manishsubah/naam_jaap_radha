import 'package:hive_ce/hive.dart';

import '../../models/app_settings.dart';
import '../../models/jaap_entry.dart';
import '../../models/naam.dart';
import '../../models/thought.dart';
import '../repositories.dart';

class HiveNaamRepository implements NaamRepository {
  HiveNaamRepository(this._box);

  final Box<Map> _box;

  @override
  List<Naam> getAll() => _box.values.map(Naam.fromMap).toList();

  @override
  Future<void> save(Naam naam) => _box.put(naam.id, naam.toMap());

  @override
  Future<void> delete(String id) => _box.delete(id);
}

class HiveJaapRepository implements JaapRepository {
  HiveJaapRepository(this._box);

  final Box<Map> _box;

  @override
  List<JaapEntry> getAll() => _box.values.map(JaapEntry.fromMap).toList();

  @override
  Future<void> save(JaapEntry entry) => _box.put(entry.id, entry.toMap());

  @override
  Future<void> delete(String id) => _box.delete(id);
}

class HiveThoughtRepository implements ThoughtRepository {
  HiveThoughtRepository(this._box);

  final Box<Map> _box;

  @override
  List<Thought> getAll() => _box.values.map(Thought.fromMap).toList();

  @override
  Future<void> save(Thought thought) => _box.put(thought.id, thought.toMap());

  @override
  Future<void> delete(String id) => _box.delete(id);
}

class HiveSettingsRepository implements SettingsRepository {
  HiveSettingsRepository(this._box);

  static const _key = 'settings';
  final Box<Map> _box;

  @override
  AppSettings load() {
    final map = _box.get(_key);
    return map == null ? const AppSettings() : AppSettings.fromMap(map);
  }

  @override
  Future<void> save(AppSettings settings) => _box.put(_key, settings.toMap());
}
