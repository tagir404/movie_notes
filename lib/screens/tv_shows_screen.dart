import 'package:flutter/material.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/screens/media_screen.dart';

class TvShowsScreen extends StatelessWidget {
  const TvShowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MediaScreen(
      type: MediaContentType.tvShow,
      emptyMessage: 'Сериалы не найдены',
    );
  }
}
