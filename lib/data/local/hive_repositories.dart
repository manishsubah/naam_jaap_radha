import 'package:hive_ce/hive.dart';

import 'package:naam_jaap/data/models/app_settings.dart';
import 'package:naam_jaap/data/models/jaap_entry.dart';
import 'package:naam_jaap/data/models/naam.dart';
import 'package:naam_jaap/data/models/thought.dart';
import 'package:naam_jaap/data/repositories/repositories.dart';

class HiveNaamRepository implements NaamRepository {
  HiveNaamRepository(this._box);

  final Box<Map> _box;

  @override
  List<Naam> getAll() => _box.values.map(Naam.fromMap).toList();

  @override
  Future<void> save(Naam naam) => _box.put(naam.id, naam.toMap());

  @override
  Future<void> saveAll(Iterable<Naam> naams) => _box.putAll({for (final n in naams) n.id: n.toMap()});
}

class HiveJaapRepository implements JaapRepository {
  HiveJaapRepository(this._box);

  final Box<Map> _box;

  @override
  List<JaapEntry> getAll() => _box.values.map(JaapEntry.fromMap).toList();

  @override
  Future<void> save(JaapEntry entry) => _box.put(entry.id, entry.toMap());

  @override
  Future<void> saveAll(Iterable<JaapEntry> entries) =>
      _box.putAll({for (final e in entries) e.id: e.toMap()});
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
