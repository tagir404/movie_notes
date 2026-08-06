import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    required this.title,
    required this.content,
    super.key,
    this.confirmText = 'Подтвердить',
    this.cancelText = 'Отмена',
  });

  final String title;
  final String content;
  final String confirmText;
  final String cancelText;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text(cancelText),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text(confirmText),
      ),
    ],
  );
}
