import 'package:flutter/material.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/widgets/pill.dart';

class MediaTypeFilter extends StatelessWidget {
  const MediaTypeFilter({
    required this.selectedType,
    required this.onChanged,
    super.key,
  });

  final MediaContentType selectedType;
  final ValueChanged<MediaContentType> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      InkWell(
        borderRadius: .circular(20),
        onTap: () => onChanged(.movie),
        child: Pill(
          borderRadius: const .only(
            topLeft: .circular(20),
            bottomLeft: .circular(20),
          ),
          padding: const .symmetric(horizontal: 12, vertical: 4),
          color: selectedType == .movie
              ? Theme.of(context).colorScheme.primary
              : null,
          child: Text(
            'Фильмы',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: selectedType == .movie ? Colors.white : null,
            ),
          ),
        ),
      ),
      InkWell(
        borderRadius: .circular(20),
        onTap: () => onChanged(.tvShow),
        child: Pill(
          borderRadius: const .only(
            topRight: .circular(20),
            bottomRight: .circular(20),
          ),
          padding: const .symmetric(horizontal: 12, vertical: 4),
          color: selectedType == .tvShow
              ? Theme.of(context).colorScheme.primary
              : null,
          child: Text(
            'Сериалы',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: selectedType == .tvShow ? Colors.white : null,
            ),
          ),
        ),
      ),
    ],
  );
}
