import 'package:material_ui/material_ui.dart';
import 'package:movie_match/enums/media_sort_option.dart';
import 'package:movie_match/widgets/pill.dart';

class MediaSortFilter extends StatelessWidget {
  const MediaSortFilter({
    required this.selectedSort,
    required this.onChanged,
    super.key,
  });

  final MediaSortOption selectedSort;
  final ValueChanged<MediaSortOption> onChanged;

  @override
  Widget build(BuildContext context) => MenuAnchor(
    builder: (BuildContext context, MenuController controller, Widget? child) =>
        Pill(
          onTap: () =>
              controller.isOpen ? controller.close() : controller.open(),
          borderRadius: .circular(20),
          padding: const .symmetric(horizontal: 12, vertical: 4),
          child: Row(
            mainAxisSize: .min,
            spacing: 8,
            children: [
              Text(
                selectedSort.label(context),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
    menuChildren: List<MenuItemButton>.generate(
      MediaSortOption.values.length,
      (int index) => MenuItemButton(
        onPressed: () => onChanged(MediaSortOption.values[index]),
        child: Text(MediaSortOption.values[index].label(context)),
      ),
    ),
  );
}
