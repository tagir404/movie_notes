import 'package:material_ui/material_ui.dart';

class Pill extends StatelessWidget {
  const Pill({
    required this.child,
    this.shape,
    this.borderRadius,
    this.padding,
    this.color,
    this.onTap,
    super.key,
  }) : assert(
         shape == null || borderRadius == null,
         'Cannot provide both shape and borderRadius.',
       );

  final ShapeBorder? shape;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    elevation: 2,
    shadowColor: Theme.of(context).colorScheme.onSurface,
    color: color,
    shape: shape,
    borderRadius: borderRadius,
    clipBehavior: .antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(padding: padding ?? const .all(0), child: child),
    ),
  );

  // @override
  // Widget build(BuildContext context) => Material(
  //   elevation: 2,
  //   shadowColor: Theme.of(context).colorScheme.onSurface,
  //   color: color,
  //   shape: shape,
  //   borderRadius: borderRadius,
  //   clipBehavior: .antiAlias,
  //   child: Padding(padding: padding ?? const .all(0), child: child),
  // );
}
