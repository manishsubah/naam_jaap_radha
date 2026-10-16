import 'package:flutter_test/flutter_test.dart';
import 'package:naam_jaap/core/utils/date_keys.dart';
import 'package:naam_jaap/features/jaap/mala_progress.dart';

void main() {
  group('MalaProgress', () {
    test('advances beads within a mala', () {
      final p = const MalaProgress(count: 0, malaSize: 108).advance().advance();
      expect(p.count, 2);
      expect(p.beadsInCurrentMala, 2);
      expect(p.completedMalas, 0);
      expect(p.isMalaBoundary, isFalse);
    });

    test('rolls over at the configured mala size', () {
      final p = const MalaProgress(count: 26, malaSize: 27).advance();
      expect(p.isMalaBoundary, isTrue);
      expect(p.completedMalas, 1);
      expect(p.beadsInCurrentMala, 0);
      expect(p.advance().beadsInCurrentMala, 1);
    });

    test('undo never goes below zero', () {
      expect(const MalaProgress(count: 0, malaSize: 108).undo().count, 0);
      expect(const MalaProgress(count: 5, malaSize: 108).undo().count, 4);
    });
  });

  group('computeStreak', () {
    final today = DateTime(2026, 3, 10);
    String daysAgo(int n) => dateKey(DateTime(2026, 3, 10 - n));

    test('counts consecutive days including today', () {
      final totals = {daysAgo(0): 108, daysAgo(1): 50, daysAgo(2): 1, daysAgo(4): 10};
      expect(computeStreak(totals, today), 3);
    });

    test('keeps yesterday streak alive when today is empty', () {
      final totals = {daysAgo(1): 108, daysAgo(2): 108};
      expect(computeStreak(totals, today), 2);
    });

    test('is zero when there is no recent jaap', () {
      expect(computeStreak({daysAgo(3): 108}, today), 0);
    });
  });
}
