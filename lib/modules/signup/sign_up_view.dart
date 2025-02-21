import 'package:flutter/material.dart';
import 'package:summarizor/core/services/responsive.dart';
import '../../core/constants/images.dart';
import 'package:summarizor/core/constants/color.dart';
import 'package:summarizor/core/constants/text_style.dart';

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
              width: double.infinity,
              height: double.infinity,
            ),

            Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 30.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.base1,
                  width: 93,
  height: 102,
                  ),

                  const SizedBox(height: 60),
//****** */
                  _buildTextField("Fullname"),
                  const SizedBox(height: 16),
                  _buildTextField("Email"),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 60),
//****** */

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                backgroundColor: PrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Sign Up", 
style: TextFormStyle.textObboardDescblack,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?", 
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        child: Text(
                          "Log In",style: TextFormStyle.textObboardtitle3,
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
          borderRadius: BorderRadius.circular(10),
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
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
          
        ), 
suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility, // تبديل الرمز
            color: Color(0xFF6BB5B8), // اللون المحدد
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // تغيير الحالة بين الإخفاء والإظهار
           });
          },
        ),
      ),
    );
  }
}