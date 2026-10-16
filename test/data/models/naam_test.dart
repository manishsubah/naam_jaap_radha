import 'package:flutter_test/flutter_test.dart';
import 'package:naam_jaap/data/models/naam.dart';

void main() {
  test('built-in naams keep their set order whatever the storage order', () {
    final shuffled = [...Naam.defaults]..sort((a, b) => a.id.compareTo(b.id));
    final names = Naam.ordered(shuffled).map((n) => n.name).take(4);
    expect(names, ['Radha', 'Ram', 'Sita-Ram', 'Krishna']);
  });

  test('a built-in naam missing from storage still appears', () {
    final withoutSitaRam = Naam.defaults.where((n) => n.id != 'sitaram');
    expect(Naam.ordered(withoutSitaRam).map((n) => n.id), contains('sitaram'));
  });

  test('custom naams follow the built-ins in the order they were added', () {
    final later = Naam(id: 'b', name: 'Shyam', script: 'श्याम', greeting: 'Jai', isCustom: true,
        updatedAt: DateTime(2026, 2));
    final earlier = Naam(id: 'a', name: 'Govind', script: 'गोविन्द', greeting: 'Jai', isCustom: true,
        updatedAt: DateTime(2026, 1));
    final names = Naam.ordered([...Naam.defaults, later, earlier]).map((n) => n.name).toList();
    expect(names.sublist(Naam.defaults.length), ['Govind', 'Shyam']);
  });

  test('removed custom naams are hidden', () {
    final removed = const Naam(id: 'x', name: 'Gone', script: 'x', greeting: 'x', isCustom: true)
        .asDeleted(DateTime(2026));
    expect(Naam.ordered([...Naam.defaults, removed]).map((n) => n.id), isNot(contains('x')));
  });
}
