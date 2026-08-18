class Country {
  const Country({
    required this.code,
    required this.englishName,
    required this.nativeName,
  });

  final String code;
  final String englishName;
  final String nativeName;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    code: json['iso_3166_1'] as String,
    englishName: json['english_name'] as String,
    nativeName: json['native_name'] as String,
  );
}
