import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final bool isDestructive;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = 'Annulla',
    this.confirmText = 'Elimina',
    this.isDestructive = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3436),
            ),
      ),
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF636E72),
              height: 1.4,
            ),
      ),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            cancelText,
            style: const TextStyle(
              color: Color(0xFF636E72),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(
            foregroundColor: isDestructive ? Colors.red.shade600 : Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            confirmText,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
