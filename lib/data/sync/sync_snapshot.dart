import 'package:naam_jaap/data/models/jaap_entry.dart';
import 'package:naam_jaap/data/models/naam.dart';

/// Everything that syncs to the user's Google account: jaap records and the
/// user's own naams (built-in naams are the same everywhere, so they're
/// left out). Tombstones are included so deletions sync too.
class SyncSnapshot {
  const SyncSnapshot({required this.entries, required this.naams});

  static const schemaVersion = 1;
  static const empty = SyncSnapshot(entries: [], naams: []);

  final List<JaapEntry> entries;
  final List<Naam> naams;

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'app': 'jaapmala',
        'exportedAt': DateTime.now().toUtc().toIso8601String(),
        'entries': [for (final e in entries) e.toMap()],
        'naams': [for (final n in naams) n.toMap()],
      };

  factory SyncSnapshot.fromJson(Map<String, dynamic> json) {
    final version = json['schemaVersion'] as int? ?? 0;
    if (version > schemaVersion) {
      throw const FormatException('Saved data is from a newer app version. Update JaapMala.');
    }
    return SyncSnapshot(
      entries: [for (final m in json['entries'] as List? ?? const []) JaapEntry.fromMap(m as Map)],
      naams: [for (final m in json['naams'] as List? ?? const []) Naam.fromMap(m as Map)],
    );
  }
}
