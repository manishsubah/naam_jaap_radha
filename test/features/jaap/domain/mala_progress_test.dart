import 'package:flutter_test/flutter_test.dart';
import 'package:naam_jaap/features/jaap/domain/mala_progress.dart';

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
}
