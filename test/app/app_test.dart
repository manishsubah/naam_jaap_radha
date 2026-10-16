import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naam_jaap/app/app.dart';
import 'package:naam_jaap/core/theme/app_theme.dart';
import 'package:naam_jaap/data/models/app_settings.dart';
import 'package:naam_jaap/data/models/jaap_entry.dart';
import 'package:naam_jaap/data/models/naam.dart';
import 'package:naam_jaap/data/models/thought.dart';
import 'package:naam_jaap/data/providers/providers.dart';
import 'package:naam_jaap/data/repositories/repositories.dart';

class _MemoryNaams implements NaamRepository {
  final _items = <String, Naam>{for (final n in Naam.defaults) n.id: n};
  @override
  List<Naam> getAll() => _items.values.toList();
  @override
  Future<void> save(Naam naam) async => _items[naam.id] = naam;
  @override
  Future<void> delete(String id) async => _items.remove(id);
}

class _MemoryJaap implements JaapRepository {
  final _items = <String, JaapEntry>{};
  @override
  List<JaapEntry> getAll() => _items.values.toList();
  @override
  Future<void> save(JaapEntry entry) async => _items[entry.id] = entry;
  @override
  Future<void> delete(String id) async => _items.remove(id);
}

class _MemoryThoughts implements ThoughtRepository {
  final _items = <String, Thought>{};
  @override
  List<Thought> getAll() => _items.values.toList();
  @override
  Future<void> save(Thought thought) async => _items[thought.id] = thought;
  @override
  Future<void> delete(String id) async => _items.remove(id);
}

class _MemorySettings implements SettingsRepository {
  AppSettings _settings = const AppSettings();
  @override
  AppSettings load() => _settings;
  @override
  Future<void> save(AppSettings settings) async => _settings = settings;
}

Widget _app() => ProviderScope(
      overrides: [
        naamRepositoryProvider.overrideWithValue(_MemoryNaams()),
        jaapRepositoryProvider.overrideWithValue(_MemoryJaap()),
        thoughtRepositoryProvider.overrideWithValue(_MemoryThoughts()),
        settingsRepositoryProvider.overrideWithValue(_MemorySettings()),
      ],
      child: const JaapMalaApp(),
    );

void main() {
  setUpAll(() => AppFonts.useGoogleFonts = false);

  testWidgets('home screen greets with the selected naam', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Radhe Radhe'), findsOneWidget);
    expect(find.text('Start Radha Jaap'), findsOneWidget);
  });

  testWidgets('tapping the mala counts a jaap', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Jaap'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('राधा'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('1'), findsOneWidget);
    expect(find.text('Mala 0  •  1/108'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });
}
