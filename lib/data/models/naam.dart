class Naam {
  const Naam({
    required this.id,
    required this.name,
    required this.script,
    required this.greeting,
    this.isCustom = false,
  });

  final String id;
  final String name;
  final String script;
  final String greeting;
  final bool isCustom;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'script': script,
        'greeting': greeting,
        'isCustom': isCustom,
      };

  factory Naam.fromMap(Map<dynamic, dynamic> map) => Naam(
        id: map['id'] as String,
        name: map['name'] as String,
        script: map['script'] as String? ?? map['name'] as String,
        greeting: map['greeting'] as String? ?? 'Jai ${map['name']}',
        isCustom: map['isCustom'] as bool? ?? false,
      );

  static const defaults = [
    Naam(id: 'radha', name: 'Radha', script: 'राधा', greeting: 'Radhe Radhe'),
    Naam(id: 'ram', name: 'Ram', script: 'राम', greeting: 'Jai Shri Ram'),
    Naam(id: 'krishna', name: 'Krishna', script: 'कृष्ण', greeting: 'Hare Krishna'),
    Naam(id: 'shiv', name: 'Om Namah Shivaya', script: 'ॐ नमः शिवाय', greeting: 'Har Har Mahadev'),
    Naam(id: 'hanuman', name: 'Hanuman', script: 'हनुमान', greeting: 'Jai Bajrangbali'),
    Naam(id: 'om', name: 'Om', script: 'ॐ', greeting: 'Om Shanti'),
    Naam(id: 'waheguru', name: 'Waheguru', script: 'ਵਾਹਿਗੁਰੂ', greeting: 'Waheguru Ji'),
  ];
}
