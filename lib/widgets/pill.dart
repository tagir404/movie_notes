import 'package:flutter/material.dart';

class Pill extends StatelessWidget {
  const Pill({
    required this.child,
    this.shape,
    this.borderRadius,
    this.padding,
    this.color,
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

  @override
  Widget build(BuildContext context) => Material(
    elevation: 6,
    color: color,
    shape: shape,
    borderRadius: borderRadius,
    child: Padding(padding: padding ?? const .all(0), child: child),
  );
}
