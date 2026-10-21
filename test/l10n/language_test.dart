import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naam_jaap/app/app.dart';
import 'package:naam_jaap/core/theme/app_theme.dart';
import 'package:naam_jaap/data/models/app_settings.dart';

import '../helpers/memory_repositories.dart';

Set<String> _arbKeys(String path) {
  final map = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  return map.keys.where((k) => !k.startsWith('@')).toSet();
}

void main() {
  setUpAll(() => AppFonts.useGoogleFonts = false);

  test('Hindi has a translation for every English string', () {
    expect(_arbKeys('lib/l10n/app_hi.arb'), _arbKeys('lib/l10n/app_en.arb'));
  });

  test('language choice survives a save and load', () {
    final saved = const AppSettings(languageCode: 'hi').toMap();
    expect(AppSettings.fromMap(saved).languageCode, 'hi');
    expect(AppSettings.fromMap(const {}).languageCode, isNull);
    expect(AppSettings.fromMap(const {'languageCode': 'fr'}).languageCode, isNull);
  });

  testWidgets('switching to Hindi shows the whole app in Hindi', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(withMemoryStorage(const JaapMalaApp()));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("Today's teaching"), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('हिन्दी').first);
    await tester.pumpAndSettle();

    expect(find.text('भाषा'), findsOneWidget);
    expect(find.text('सेटिंग्स'), findsWidgets);
    expect(find.text('Settings'), findsNothing);

    await tester.tap(find.text('मुख्य'));
    // Home has a looping diya animation, so it never settles.
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('राधे राधे'), findsOneWidget);
    expect(find.text('राधा जाप शुरू करें'), findsOneWidget);
    expect(find.text('आज का वचन'), findsOneWidget);
    expect(find.text('Radhe Radhe'), findsNothing);

    await tester.tap(find.text('सेटिंग्स').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').first);
    await tester.pumpAndSettle();
    expect(find.text('Language'), findsOneWidget);
  });
}
