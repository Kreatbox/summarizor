import 'package:flutter/material.dart';
import 'package:summarizor/core/constants/app_routes.dart';
import 'package:summarizor/core/services/responsive.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/constants/app_images.dart';
import 'package:summarizor/modules/sign_up/sign_up_controller.dart';
class SingUpView extends StatefulWidget {
  const SingUpView({super.key});

  @override
  State<SingUpView> createState() => _SingUpViewState();
}
class _SingUpViewState extends State<SingUpView> {

  final _formKey = GlobalKey<FormState>();
  final SignUpController _controller = SignUpController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              Images.appLogo,
              fit: BoxFit.cover,
              width: 412.w,
            ),
            Padding(
              padding:10.ph+ 30.pv,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(
                    width: 93.w,
                    height: 102.h,
                    child: Image.asset(Images.appIcon),
                  ),

                  SizedBox(height: 60.h),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildlabelLarge("Fullname", _fullNameController, TextInputType.name, (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Fullname';
                            }
                             return null;
                        }),
                        SizedBox(height: 16.h),
                        _buildlabelLarge("Email", _emailController, TextInputType.emailAddress, (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Email';
                            }
                            if (!value.contains('@') || !value.contains('.com')) {
                              return 'Please enter a valid Email';
                            }
                            return null;
                        }),
                        SizedBox(height: 16.h),
                         _buildPasswordField(_passwordController, (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (!value.contains(RegExp(r'[0-9]'))) {
                              return 'Password must contain at least one number';
                            }
                            return null;
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 60.h),
                  _isLoading ? CircularProgressIndicator(color: AppColors.primary,) : SizedBox(width: double.infinity, height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                          if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                               _controller.signUp(
                                 fullName: _fullNameController.text,
                                 email: _emailController.text,
                                 password: _passwordController.text,
                                 context: context,
                               );
                              if (!mounted) return;
                              final currentContext = context;
                              setState(() {
                                _isLoading = false;
                                ScaffoldMessenger.of(currentContext).showSnackBar(
                                  SnackBar(content: Text("An error occurred")));
                                  });
                            }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        "Sign Up",
                        style: Theme.of(context).textTheme.bodyMedium,
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
                          Navigator.pushNamed(context, AppRoute.logIn);
                        },
                        child: Text(
                          "Log In",
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

  Widget _buildlabelLarge(String label, TextEditingController controller,
    TextInputType keyboardType, String? Function(String?)? validator) {
    return TextFormField(
      controller: controller,
        validator: validator,

      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        errorStyle: const TextStyle(color: Colors.red),
        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        labelStyle: Theme.of(context).textTheme.labelLarge,
        filled: true,
        fillColor: Color(0x1A6BB5B8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),

     );
  }

  Widget _buildPasswordField(TextEditingController controller,
      String? Function(String?)? validator) {
    return TextFormField(
      controller: controller,
        validator: validator,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: "Password",errorStyle: const TextStyle(color: Colors.red),
        labelStyle: Theme.of(context).textTheme.labelLarge,
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
