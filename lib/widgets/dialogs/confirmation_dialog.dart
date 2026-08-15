import 'package:material_ui/material_ui.dart';
import '../../l10n/app_localizations.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    required this.title,
    required this.content,
    super.key,
    this.confirmText,
    this.cancelText,
  });

  final String title;
  final String content;
  final String? confirmText;
  final String? cancelText;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final cancel = cancelText ?? loc!.dialog_cancel;
    final confirm = confirmText ?? loc!.dialog_confirm;

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirm),
        ),
      ],
    );
  }
}
