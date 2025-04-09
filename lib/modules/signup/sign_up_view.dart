import 'package:flutter/material.dart';
import 'package:summarizor/core/services/responsive.dart';
import '../../core/constants/images.dart';
import 'package:summarizor/core/constants/color.dart';
import 'package:summarizor/core/constants/text_style.dart';
import 'package:summarizor/core/services/navigation.dart';

import '../home_screen/homes_screen.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(
                    width: 93.w,
                    height: 102.h,
                    child: Image.asset(Images.base1),
                  ),

                  SizedBox(height: 60.h),
//****** */
                  _buildTextField("Fullname"),
                  SizedBox(height: 16.h),
                  _buildTextField("Email"),
                  SizedBox(height: 16.h),
                  _buildPasswordField(),
                  SizedBox(height: 60.h),
//****** */

                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigation.navigateAndRemove(context, HomesScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextFormStyle.textObboardDescblack,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/log_in_view");
                        },
                        child: Text(
                          "Log In",
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
        fillColor: Color(0x1A6BB5B8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextFormStyle.textfield,
        filled: true,
        fillColor: Color(0x1A6BB5B8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off
                : Icons.visibility,
            color: Color(0xFF6BB5B8),
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
