import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:naam_jaap/data/models/app_settings.dart';
import 'package:naam_jaap/data/models/jaap_entry.dart';
import 'package:naam_jaap/data/models/naam.dart';
import 'package:naam_jaap/data/models/thought.dart';
import 'package:naam_jaap/data/providers/providers.dart';
import 'package:naam_jaap/data/repositories/repositories.dart';

class MemoryNaams implements NaamRepository {
  final items = <String, Naam>{for (final n in Naam.defaults) n.id: n};
  @override
  List<Naam> getAll() => items.values.toList();
  @override
  Future<void> save(Naam naam) async => items[naam.id] = naam;
  @override
  Future<void> saveAll(Iterable<Naam> naams) async => naams.forEach(save);
}

class MemoryJaap implements JaapRepository {
  MemoryJaap([Iterable<JaapEntry> initial = const []]) {
    for (final e in initial) {
      items[e.id] = e;
    }
  }

  final items = <String, JaapEntry>{};
  @override
  List<JaapEntry> getAll() => items.values.toList();
  @override
  Future<void> save(JaapEntry entry) async => items[entry.id] = entry;
  @override
  Future<void> saveAll(Iterable<JaapEntry> entries) async => entries.forEach(save);
}

class MemoryThoughts implements ThoughtRepository {
  final _items = <String, Thought>{};
  @override
  List<Thought> getAll() => _items.values.toList();
  @override
  Future<void> save(Thought thought) async => _items[thought.id] = thought;
  @override
  Future<void> delete(String id) async => _items.remove(id);
}

class MemorySettings implements SettingsRepository {
  AppSettings _settings = const AppSettings();
  @override
  AppSettings load() => _settings;
  @override
  Future<void> save(AppSettings settings) async => _settings = settings;
}

/// The app's providers backed by in-memory storage.
List<Override> memoryOverrides({MemoryNaams? naams, MemoryJaap? jaap}) => [
      naamRepositoryProvider.overrideWithValue(naams ?? MemoryNaams()),
      jaapRepositoryProvider.overrideWithValue(jaap ?? MemoryJaap()),
      thoughtRepositoryProvider.overrideWithValue(MemoryThoughts()),
      settingsRepositoryProvider.overrideWithValue(MemorySettings()),
    ];

Widget withMemoryStorage(Widget child, {MemoryJaap? jaap}) =>
    ProviderScope(overrides: memoryOverrides(jaap: jaap), child: child);
