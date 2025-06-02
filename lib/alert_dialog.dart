import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction?> yesAbort(
    BuildContext context,
    String title,
    String content,
    String yesText,
    String noText,
  ) async {
    final DialogAction? action = await showDialog<DialogAction>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          content: Text(
            content,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.abort),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .error
                    .withValues(alpha: 0.2), // Light error shade
                foregroundColor: Theme.of(context)
                    .colorScheme
                    .error, // Error color for text/icon
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                minimumSize: const Size(100, 40), // Consistent button size
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    EvaIcons.close,
                    color: Theme.of(context).colorScheme.error,
                    size: 20.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    noText,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.yes),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.2), // Light accent shade
                foregroundColor: Theme.of(context)
                    .colorScheme
                    .primaryContainer, // Accent color for text/icon
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                minimumSize: const Size(100, 40), // Consistent button size
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    EvaIcons.checkmark,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    size: 20.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    yesText,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    return action ??
        DialogAction.abort; // Default to abort if dialog is dismissed
  }
}
