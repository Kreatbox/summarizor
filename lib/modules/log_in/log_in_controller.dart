import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizor/core/services/cache_manager.dart';

class LoginController with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final CacheManager cacheManager = CacheManager();

  Future<void> _showAutoDismissDialog({
    required BuildContext context,
    required String title,
    required String content,
    required IconData iconData,
    required Color iconColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Future.delayed(duration, () {
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          icon: Icon(iconData, color: iconColor, size: 48),
          title: Text(title, textAlign: TextAlign.center),
          content: Text(content, textAlign: TextAlign.center),
        );
      },
    );
  }

  /// Attempts to sign in the user, cache their data, and returns the userToken (UID).
  Future<String?> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final String fullName = userDoc['fullName'];
        await cacheManager.cacheUser(email, uid, fullName);
      }

      if (!context.mounted) return uid;

      await _showAutoDismissDialog(
        context: context,
        title: 'Success',
        content: 'Login successful! Redirecting...',
        iconData: Icons.check_circle_outline_rounded,
        iconColor: Colors.green,
        duration: const Duration(seconds: 2),
      );
      return uid;

    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return null;

      String errorMessage = "An unknown error occurred.";
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        errorMessage = "No user found for that email or password is incorrect.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided for that user.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email provided is invalid.";
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      await _showAutoDismissDialog(
        context: context,
        title: 'Login Failed',
        content: errorMessage,
        iconData: Icons.error_outline_rounded,
        iconColor: Colors.red,
        duration: const Duration(seconds: 3),
      );
      return null;

    } catch (e) {
      if (!context.mounted) return null;

      await _showAutoDismissDialog(
        context: context,
        title: 'Error',
        content: 'An unexpected error occurred. Please try again.',
        iconData: Icons.error_outline_rounded,
        iconColor: Colors.red,
        duration: const Duration(seconds: 3),
      );
      return null;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
