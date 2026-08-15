import 'package:material_ui/material_ui.dart';

class SwiperAction extends StatelessWidget {
  const SwiperAction({
    required this.text,
    required this.isActive,
    required this.iconOnRight,
    super.key,
  });

  final String text;
  final bool isActive;
  final bool iconOnRight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        spacing: 8,
        children: iconOnRight
            ? [
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isActive
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                ),
                Icon(
                  Icons.swipe_right,
                  size: 16,
                  color: isActive
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
              ]
            : [
                Icon(
                  Icons.swipe_left,
                  size: 16,
                  color: isActive
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isActive
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                ),
              ],
      ),
    );
  }
}
