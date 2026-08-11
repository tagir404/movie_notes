class MovieCastMember {
  const MovieCastMember({
    required this.name,
    required this.profilePath,
    required this.character,
  });

  final String name;
  final String? profilePath;
  final String character;

  factory MovieCastMember.fromJson(Map<String, dynamic> json) =>
      MovieCastMember(
        name: json['name'] as String? ?? 'Неизвестно',
        profilePath: json['profile_path'] as String?,
        character: json['character'] as String? ?? '',
      );
}
