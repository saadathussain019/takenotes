import 'package:flutter/material.dart';
import 'package:takenotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this item?',
    optionsBuilder: () => {
      'CANCEL': false,
      'DELETE': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
