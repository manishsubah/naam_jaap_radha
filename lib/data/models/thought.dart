enum ThoughtMood {
  peaceful('Peaceful'),
  grateful('Grateful'),
  devoted('Devoted'),
  joyful('Joyful'),
  seeking('Seeking');

  const ThoughtMood(this.label);
  final String label;
}

class Thought {
  const Thought({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    this.mood,
    this.audioPath,
    this.audioDurationMs,
  });

  final String id;
  final String text;
  final ThoughtMood? mood;
  final String? audioPath;
  final int? audioDurationMs;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get hasAudio => audioPath != null;

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'mood': mood?.name,
        'audioPath': audioPath,
        'audioDurationMs': audioDurationMs,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Thought.fromMap(Map<dynamic, dynamic> map) {
    final moodName = map['mood'] as String?;
    return Thought(
      id: map['id'] as String,
      text: map['text'] as String? ?? '',
      mood: ThoughtMood.values.where((m) => m.name == moodName).firstOrNull,
      audioPath: map['audioPath'] as String?,
      audioDurationMs: map['audioDurationMs'] as int?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
