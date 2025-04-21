import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizor/core/constants/app_routes.dart';
import 'package:summarizor/core/services/navigation.dart';
import 'package:summarizor/core/services/cache_manager.dart';

class LoginController with ChangeNotifier {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
    final CacheManager cacheManager = CacheManager();


  Future<void> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        final String fullName = userDoc['fullName'];
        await cacheManager.cacheUser(email, uid, fullName);
      }
      final currentContext = context;
      if (!currentContext.mounted) return;
      ScaffoldMessenger.of(currentContext)
          .showSnackBar(const SnackBar(content: Text("Login successful!")));
      Navigation.navigateAndRemove(currentContext, AppRoute.home);
    } on FirebaseAuthException catch (e) {
      final currentContext = context;
      if (!currentContext.mounted) return;
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(content: Text("No user found for that email.")));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(currentContext).showSnackBar(const SnackBar(content: Text("Wrong password provided for that user.")));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(currentContext).showSnackBar(const SnackBar(content: Text("The email provided is invalid.")));
      } else {
        ScaffoldMessenger.of(currentContext).showSnackBar(SnackBar(content: Text(e.message ?? "An error occurred")));
      }
    } catch (e) {
      final currentContext = context;
      if (!currentContext.mounted) return;
      ScaffoldMessenger.of(currentContext)
          .showSnackBar(SnackBar(content: Text('An unexpected error occurred')));
    }
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}