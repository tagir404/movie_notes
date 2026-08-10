class MovieVideo {
  MovieVideo({
    required this.key,
    required this.name,
    required this.type,
    required this.site,
    required this.official,
  });

  final String key;
  final String name;
  final String type;
  final String site;
  final bool official;

  factory MovieVideo.fromJson(Map<String, dynamic> json) => MovieVideo(
    key: json['key'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    site: json['site'] as String,
    official: json['official'] as bool,
  );
}
