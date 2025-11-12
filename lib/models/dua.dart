class Dua {
  final String id;
  final String title;
  final String arabicText;
  final String transliteration;
  final String translation;
  final String category;
  final String reference;
  final String? audioUrl;
  final bool isFavorite;

  Dua({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.category,
    required this.reference,
    this.audioUrl,
    this.isFavorite = false,
  });

  Dua copyWith({
    String? id,
    String? title,
    String? arabicText,
    String? transliteration,
    String? translation,
    String? category,
    String? reference,
    String? audioUrl,
    bool? isFavorite,
  }) {
    return Dua(
      id: id ?? this.id,
      title: title ?? this.title,
      arabicText: arabicText ?? this.arabicText,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      category: category ?? this.category,
      reference: reference ?? this.reference,
      audioUrl: audioUrl ?? this.audioUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabicText': arabicText,
      'transliteration': transliteration,
      'translation': translation,
      'category': category,
      'reference': reference,
      'audioUrl': audioUrl,
      'isFavorite': isFavorite,
    };
  }

  factory Dua.fromJson(Map<String, dynamic> json) {
    return Dua(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      arabicText: json['arabicText'] ?? '',
      transliteration: json['transliteration'] ?? '',
      translation: json['translation'] ?? '',
      category: json['category'] ?? '',
      reference: json['reference'] ?? '',
      audioUrl: json['audioUrl'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
