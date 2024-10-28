import 'package:flutter/material.dart';

Future<bool?> confirmPlaceDeletion(BuildContext context, String title, String address) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: Text(
        "Are you sure you want to delete $title, $address?",
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    ),
  );
}
