import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naam_jaap/data/providers/providers.dart';

import '../../helpers/memory_repositories.dart';

void main() {
  test('setting a count to zero keeps a tombstone for sync', () async {
    final jaap = MemoryJaap();
    final container = ProviderContainer(overrides: memoryOverrides(jaap: jaap));
    addTearDown(container.dispose);
    final notifier = container.read(jaapEntriesProvider.notifier);

    await notifier.setCount('2026-10-01', 'radha', 108);
    await notifier.setCount('2026-10-01', 'radha', 0);

    expect(container.read(jaapEntriesProvider), isEmpty);
    expect(jaap.items.values.single.deleted, isTrue);
  });

  test('deleted records stay hidden after a restart', () async {
    final jaap = MemoryJaap();
    final first = ProviderContainer(overrides: memoryOverrides(jaap: jaap));
    await first.read(jaapEntriesProvider.notifier).setCount('2026-10-01', 'radha', 108);
    await first.read(jaapEntriesProvider.notifier).setCount('2026-10-01', 'radha', 0);
    first.dispose();

    final second = ProviderContainer(overrides: memoryOverrides(jaap: jaap));
    addTearDown(second.dispose);
    expect(second.read(jaapEntriesProvider), isEmpty);
  });
}
