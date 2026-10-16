class JaapEntry {
  const JaapEntry({
    required this.dateKey,
    required this.naamId,
    required this.count,
    required this.updatedAt,
  });

  final String dateKey;
  final String naamId;
  final int count;
  final DateTime updatedAt;

  String get id => idFor(dateKey, naamId);

  static String idFor(String dateKey, String naamId) => '$dateKey|$naamId';

  JaapEntry copyWith({int? count, DateTime? updatedAt}) => JaapEntry(
        dateKey: dateKey,
        naamId: naamId,
        count: count ?? this.count,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toMap() => {
        'dateKey': dateKey,
        'naamId': naamId,
        'count': count,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory JaapEntry.fromMap(Map<dynamic, dynamic> map) => JaapEntry(
        dateKey: map['dateKey'] as String,
        naamId: map['naamId'] as String,
        count: map['count'] as int,
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
}
