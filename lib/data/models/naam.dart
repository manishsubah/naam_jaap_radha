class Naam {
  const Naam({
    required this.id,
    required this.name,
    required this.script,
    required this.greeting,
    this.isCustom = false,
    this.updatedAt,
    this.deleted = false,
  });

  final String id;
  final String name;
  final String script;
  final String greeting;
  final bool isCustom;

  /// Null for the built-in naams, which never change.
  final DateTime? updatedAt;

  /// Tombstone for a removed custom naam, kept so the removal syncs.
  final bool deleted;

  Naam asDeleted(DateTime at) => Naam(
        id: id,
        name: name,
        script: script,
        greeting: greeting,
        isCustom: isCustom,
        updatedAt: at,
        deleted: true,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'script': script,
        'greeting': greeting,
        'isCustom': isCustom,
        if (updatedAt != null) 'updatedAt': updatedAt!.toUtc().toIso8601String(),
        'deleted': deleted,
      };

  factory Naam.fromMap(Map<dynamic, dynamic> map) => Naam(
        id: map['id'] as String,
        name: map['name'] as String,
        script: map['script'] as String? ?? map['name'] as String,
        greeting: map['greeting'] as String? ?? 'Jai ${map['name']}',
        isCustom: map['isCustom'] as bool? ?? false,
        updatedAt: map['updatedAt'] == null ? null : DateTime.parse(map['updatedAt'] as String),
        deleted: map['deleted'] as bool? ?? false,
      );

  /// Built-in naams, in the order they're shown everywhere in the app.
  static const defaults = [
    Naam(id: 'radha', name: 'Radha', script: 'राधा', greeting: 'Radhe Radhe'),
    Naam(id: 'ram', name: 'Ram', script: 'राम', greeting: 'Jai Shri Ram'),
    Naam(id: 'sitaram', name: 'Sita-Ram', script: 'सीताराम', greeting: 'Jai Siya Ram'),
    Naam(id: 'krishna', name: 'Krishna', script: 'कृष्ण', greeting: 'Hare Krishna'),
    Naam(id: 'shiv', name: 'Om Namah Shivaya', script: 'ॐ नमः शिवाय', greeting: 'Har Har Mahadev'),
    Naam(id: 'hanuman', name: 'Hanuman', script: 'हनुमान', greeting: 'Jai Bajrangbali'),
    Naam(id: 'om', name: 'Om', script: 'ॐ', greeting: 'Om Shanti'),
    Naam(id: 'waheguru', name: 'Waheguru', script: 'ਵਾਹਿਗੁਰੂ', greeting: 'Waheguru Ji'),
  ];

  /// The naams to show: every built-in naam in [defaults] order (including
  /// ones added in later app versions), then the user's own naams in the
  /// order they were added. Storage order is ignored.
  static List<Naam> ordered(Iterable<Naam> saved) {
    final live = {for (final n in saved) if (!n.deleted) n.id: n};
    final builtInIds = {for (final d in defaults) d.id};
    final custom = live.values.where((n) => !builtInIds.contains(n.id)).toList()
      ..sort((a, b) => (a.updatedAt ?? DateTime(2000)).compareTo(b.updatedAt ?? DateTime(2000)));
    return [
      for (final d in defaults) live[d.id] ?? d,
      ...custom,
    ];
  }
}
