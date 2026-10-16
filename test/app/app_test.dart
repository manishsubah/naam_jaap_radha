import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naam_jaap/app/app.dart';
import 'package:naam_jaap/core/theme/app_theme.dart';

import '../helpers/memory_repositories.dart';

Widget _app() => withMemoryStorage(const JaapMalaApp());

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
