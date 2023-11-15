import 'package:flutter/material.dart';


class SnackbarShare {
  static final SnackbarShare _instance = SnackbarShare._internal();

  factory SnackbarShare() => _instance;

  SnackbarShare._internal();

  static BuildContext? _context;

  static void init(BuildContext context) {
    _context = context;
  }

  static void showMessage(String message) {
    if (_context == null) {
      throw Exception(
          "SnackbarShare not initialized. Call init(BuildContext context) first.");
    }
    final ThemeData theme = Theme.of(_context!);
    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        backgroundColor: theme.hintColor,
        content: Text(message,style: theme.textTheme.titleMedium,textAlign: TextAlign.center,textDirection: TextDirection.rtl,),
        duration: const Duration(seconds: 4),
      ),
    );
  }


}
