import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthmate/features/authentication/models/custom_error.dart';
import 'package:recase/recase.dart';

void errorDialog(BuildContext context, CustomError error) {
  if (Platform.isIOS || Platform.isMacOS) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(error.code.titleCase),
          content: Text('${error.plugin} \n ${error.message}'),
          actions: [
            CupertinoDialogAction(
              child: const Text("Okay"),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(error.code.titleCase),
          content: Text(error.message),
          actions: [
            TextButton(
              child: const Text("Okay"),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        );
      },
    );
  }
}
