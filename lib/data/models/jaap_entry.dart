/// One day's jaap count for one naam.
///
/// Deletions are kept as tombstones ([deleted] = true) so a removal on one
/// device wins over an older copy of the record on another device when synced.
class JaapEntry {
  const JaapEntry({
    required this.dateKey,
    required this.naamId,
    required this.count,
    required this.updatedAt,
    this.deleted = false,
  });

  final String dateKey;
  final String naamId;
  final int count;
  final DateTime updatedAt;
  final bool deleted;

  String get id => idFor(dateKey, naamId);

  static String idFor(String dateKey, String naamId) => '$dateKey|$naamId';

  JaapEntry copyWith({int? count, DateTime? updatedAt, bool? deleted}) => JaapEntry(
        dateKey: dateKey,
        naamId: naamId,
        count: count ?? this.count,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
      );

  Map<String, dynamic> toMap() => {
        'dateKey': dateKey,
        'naamId': naamId,
        'count': count,
        'updatedAt': updatedAt.toUtc().toIso8601String(),
        'deleted': deleted,
      };

  factory JaapEntry.fromMap(Map<dynamic, dynamic> map) => JaapEntry(
        dateKey: map['dateKey'] as String,
        naamId: map['naamId'] as String,
        count: map['count'] as int,
        updatedAt: DateTime.parse(map['updatedAt'] as String),
        deleted: map['deleted'] as bool? ?? false,
      );
}
