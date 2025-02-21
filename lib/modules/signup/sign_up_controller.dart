import 'package:flutter/material.dart';
import 'package:summarizor/modules/signup/sign_up_controller.dart' as emailController;
import 'package:summarizor/modules/signup/sign_up_controller.dart' as passwordController;
import 'package:summarizor/modules/signup/sign_up_controller.dart' as fullNameController;

class RegisterController with ChangeNotifier {
  bool isVisible = true;
  bool success = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  void togglePasswordVisibility() {
    isVisible = !isVisible;
    notifyListeners(); 
  }

  Future<void> register({
    required BuildContext context,
  }) async {

      notifyListeners(); 

      if (success) {
        Navigator.pushNamed(context, "/login");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed! Please try again.")),
        );
      }
    } 
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
  }

