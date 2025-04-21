import 'package:flutter/material.dart';

class Navigation {
  static void navigateTo(BuildContext context, String name) {
    Navigator.pushNamed(context, name);
  }

  static void navigateAndRemove(BuildContext context, String name) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      name,
      (route) => false,
    );
  }

  static void pop_(BuildContext context) {
    Navigator.pop(context);
  }

  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // Show a message for a specific time when there is no back screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No back screen available!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
