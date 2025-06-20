import 'package:flutter/material.dart';
import 'package:summarizor/modules/log_in/log_in_controller.dart';
import '../../core/constants/app_images.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/services/responsive.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});
  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  final _formKey = GlobalKey<FormState>();
  final LoginController _controller = LoginController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Image.asset(
              Images.appLogo,
              fit: BoxFit.cover,
              width: 412.w,
            ),
            Padding(
              padding:  20.ph+ 30.pv,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    Images.appIcon,
                    width: 93.w,
                    height: 102.h,
                  ),
                  SizedBox(height: 60.h),
                   SizedBox(
                    child: Text("Email",style: Theme.of(context).textTheme.labelLarge,),
                  ),
                  SizedBox(height: 16.h),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildEmailField(_emailController),
                        SizedBox(height: 16.h),
                        _buildPasswordField(_passwordController),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  _isLoading
                      ? CircularProgressIndicator(
                          color: AppColors.primary,
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                               _controller.login(email: _emailController.text, password: _passwordController.text, context: context);
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Log In",
                              style: Theme.of(context).textTheme.bodyMedium,
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
                          style: Theme.of(context).textTheme.displaySmall,
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

  Widget _buildEmailField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red),
          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        filled: true,
        fillColor:  Color(0x1A6BB5B8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your Email';
          }
          if (!value.contains('@') || !value.contains('.com')) {
            return 'Please enter a valid Email';
          }
          return null;
        },
      );
  }

  Widget _buildPasswordField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.red),
        labelText: "Password",
        labelStyle: Theme.of(context).textTheme.labelLarge,
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      );
  }
}
