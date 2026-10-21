import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naam_jaap/app/app.dart';
import 'package:naam_jaap/core/theme/app_theme.dart';
import 'package:naam_jaap/core/utils/date_keys.dart';
import 'package:naam_jaap/data/models/jaap_entry.dart';

import '../../../helpers/memory_repositories.dart';

Future<void> _openLog(WidgetTester tester, {MemoryJaap? jaap}) async {
  await tester.pumpWidget(withMemoryStorage(const JaapMalaApp(), jaap: jaap));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.text('History'));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => AppFonts.useGoogleFonts = false);

  testWidgets('adds a record through the form', (tester) async {
    await _openLog(tester);
    expect(find.text('Start your jaap log'), findsOneWidget);

    await tester.tap(find.text('Add record'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save record'));
    await tester.pumpAndSettle();
    expect(find.text('Enter how many times you chanted'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('record-count')), '108');
    await tester.pump();
    expect(tester.widget<Text>(find.byKey(const Key('record-total'))).data, '108');
    await tester.tap(find.text('Save record'));
    await tester.pumpAndSettle();

    expect(find.text('Start your jaap log'), findsNothing);
    expect(find.text('Radha'), findsOneWidget);
    expect(find.text('108'), findsNWidgets(2));
  });

  testWidgets('shows running totals and edits an existing day', (tester) async {
    final today = dayOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));
    final jaap = MemoryJaap([
      JaapEntry(dateKey: dateKey(yesterday), naamId: 'radha', count: 108, updatedAt: DateTime(2026)),
      JaapEntry(dateKey: dateKey(today), naamId: 'radha', count: 216, updatedAt: DateTime(2026)),
    ]);
    await _openLog(tester, jaap: jaap);

    expect(find.text('324'), findsOneWidget);

    await tester.tap(find.text('216'));
    await tester.pumpAndSettle();
    expect(find.text('Update jaap record'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('record-count')), '300');
    await tester.tap(find.text('Update record'));
    await tester.pumpAndSettle();

    expect(find.text('408'), findsOneWidget);
    expect(jaap.items[JaapEntry.idFor(dateKey(today), 'radha')]!.count, 300);
  });

  testWidgets('adds an external count on top of the existing one', (tester) async {
    final today = dayOnly(DateTime.now());
    final jaap = MemoryJaap([
      JaapEntry(dateKey: dateKey(today), naamId: 'radha', count: 216, updatedAt: DateTime(2026)),
    ]);
    await _openLog(tester, jaap: jaap);
    expect(find.text("Today's count"), findsOneWidget);

    await tester.tap(find.text('216').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('record-add-more')), '108');
    await tester.pump();
    await tester.tap(find.byKey(const Key('record-add-more-button')));
    await tester.pump();

    final count = tester.widget<TextFormField>(find.byKey(const Key('record-count')));
    expect(count.controller!.text, '324');
    expect(tester.widget<TextField>(find.byKey(const Key('record-add-more'))).controller!.text, '');
    expect(tester.widget<Text>(find.byKey(const Key('record-total'))).data, '324');

    await tester.tap(find.text('Update record'));
    await tester.pumpAndSettle();
    expect(jaap.items[JaapEntry.idFor(dateKey(today), 'radha')]!.count, 324);
  });
}
