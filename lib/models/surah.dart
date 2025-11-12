class Surah {
  final int number;
  final String name;
  final String arabicName;
  final int verses;
  final String revelationType;
  final String? meaning;
  final List<Verse>? versesList;

  Surah({
    required this.number,
    required this.name,
    required this.arabicName,
    required this.verses,
    required this.revelationType,
    this.meaning,
    this.versesList,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      arabicName: json['arabicName'] ?? '',
      verses: json['verses'] ?? 0,
      revelationType: json['revelationType'] ?? 'Meccan',
      meaning: json['meaning'],
      versesList: json['versesList'] != null
          ? (json['versesList'] as List)
              .map((v) => Verse.fromJson(v))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'arabicName': arabicName,
      'verses': verses,
      'revelationType': revelationType,
      'meaning': meaning,
      'versesList': versesList?.map((v) => v.toJson()).toList(),
    };
  }
}

class Verse {
  final int number;
  final String arabicText;
  final String? translation;
  final String? transliteration;

  Verse({
    required this.number,
    required this.arabicText,
    this.translation,
    this.transliteration,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      number: json['number'] ?? 0,
      arabicText: json['arabicText'] ?? '',
      translation: json['translation'],
      transliteration: json['transliteration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'arabicText': arabicText,
      'translation': translation,
      'transliteration': transliteration,
    };
  }
}
