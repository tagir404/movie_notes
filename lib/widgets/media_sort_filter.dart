import 'package:flutter/material.dart';
import 'package:movie_notes/enums/media_sort_option.dart';
import 'package:movie_notes/widgets/pill.dart';

class MediaSortFilter extends StatelessWidget {
  const MediaSortFilter({
    required this.selectedSort,
    required this.onChanged,
    super.key,
  });

  final MediaSortOption selectedSort;
  final ValueChanged<MediaSortOption> onChanged;

  @override
  Widget build(BuildContext context) => PopupMenuButton<MediaSortOption>(
    initialValue: selectedSort,
    onSelected: onChanged,
    itemBuilder: (context) => MediaSortOption.values
        .map(
          (option) => PopupMenuItem(value: option, child: Text(option.label)),
        )
        .toList(),
    child: Pill(
      borderRadius: .circular(20),
      padding: const .symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisSize: .min,
        spacing: 8,
        children: [
          Text(
            selectedSort.label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
          ),
          const Icon(Icons.arrow_drop_down, size: 20),
        ],
      ),
    ),
  );
}
