import 'package:flutter/material.dart';

class Pill extends StatelessWidget {
  const Pill({
    required this.child,
    this.shape,
    this.borderRadius,
    this.padding,
    super.key,
  }) : assert(
         shape == null || borderRadius == null,
         'Cannot provide both shape and borderRadius.',
       );

  final ShapeBorder? shape;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      elevation: 6,
      shape: shape,
      borderRadius: borderRadius,
      child: Padding(
        padding: padding ?? const .symmetric(vertical: 4, horizontal: 12),
        child: child,
      ),
    );
  }
}
