import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizor/core/constants/app_routes.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:summarizor/core/services/navigation.dart';

class SignUpController with ChangeNotifier {
  bool isVisible = true;
  bool success = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
      final CacheManager cacheManager = CacheManager();

  void togglePasswordVisibility() {
    isVisible = !isVisible;
    notifyListeners(); 
  }
  Future<void> signUp({required String email, required String password, required String fullName, required BuildContext context}) async {
    notifyListeners();
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
      });
      final currentContext = context;
      if (!currentContext.mounted) return;
      ScaffoldMessenger.of(currentContext).showSnackBar(const SnackBar(content: Text("Sign Up successful!")));
      await cacheManager.cacheUser(email, userCredential.user!.uid, fullName);
      if (!currentContext.mounted) return;
      Navigation.navigateAndRemove(currentContext, AppRoute.home);
    } on FirebaseAuthException catch (e) {
      final currentContext = context;
      if (!currentContext.mounted) return;
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(currentContext).showSnackBar(const SnackBar(content: Text("The password provided is too weak.")));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(currentContext).showSnackBar(const SnackBar(content: Text("The account already exists for that email.")));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(currentContext).showSnackBar(const SnackBar(content: Text("The email provided is invalid.")));
      } else {
        ScaffoldMessenger.of(currentContext).showSnackBar(SnackBar(content: Text(e.message ?? "An error occurred")));
      }
    } on FirebaseException catch (e) {
     final currentContext = context;
      if (!currentContext.mounted) return;
        ScaffoldMessenger.of(currentContext).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    } catch (e) {
      final currentContext = context;
      if (!currentContext.mounted) return;
      ScaffoldMessenger.of(currentContext).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    }
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }
}
