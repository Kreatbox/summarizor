import 'package:flutter/material.dart';
import '../../core/constants/images.dart';
import 'package:summarizor/core/constants/color.dart';
import 'package:summarizor/core/constants/text_style.dart';
import 'package:summarizor/core/services/responsive.dart';

import '../../core/services/navigation.dart';
import '../home_screen/homes_screen.dart';
class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              Images.base,
              fit: BoxFit.cover,
              width: 412.w,

            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.base1,
                    width: 93.w,
                    height: 102.h,
                  ),
                   SizedBox(height: 60.h),
                  _buildTextField("Email"),
                   SizedBox(height: 16.h),
                  _buildPasswordField(),
                   SizedBox(height: 40.h),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigation.navigateAndRemove( context, HomesScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Log In",
                        style: TextFormStyle.textObboardDescblack,
                      ),
                    ),
                  ),

                   SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                        child: Text(
                          "Sign Up",
                          style: TextFormStyle.textObboardtitle3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextFormStyle.textfield,
        filled: true,
        fillColor:  Color(0x1A6BB5B8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextFormStyle.textfield,
        filled: true,
        fillColor:  Color(0x1A6BB5B8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color:  Color(0xFF6BB5B8),
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
