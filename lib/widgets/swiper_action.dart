import 'package:material_ui/material_ui.dart';

class SwiperAction extends StatelessWidget {
  const SwiperAction({
    required this.text,
    required this.isActive,
    required this.iconAfterText,
    super.key,
  });

  final String text;
  final bool isActive;
  final bool iconAfterText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final children = [
      Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isActive
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
        ),
      ),
      Icon(
        iconAfterText ? Icons.swipe_right : Icons.swipe_left,
        size: 16,
        color: isActive
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
      ),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const .symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary : Colors.transparent,
        borderRadius: .circular(20),
      ),
      child: Row(
        spacing: 8,
        children: iconAfterText ? children : children.reversed.toList(),
      ),
    );
  }
}
