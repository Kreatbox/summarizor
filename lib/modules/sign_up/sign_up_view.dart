import 'package:flutter/material.dart';
import 'package:summarizor/core/constants/app_routes.dart';
import 'package:summarizor/core/services/responsive.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/constants/app_images.dart';
import 'package:summarizor/modules/sign_up/sign_up_controller.dart';
import '../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
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
              padding: 10.ph + 30.pv,
              child: SingleChildScrollView(
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
                          _buildlabelLarge(
                              l10n.fullName, _fullNameController,
                              TextInputType.name, (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.pleaseEnterFullName;
                            }
                            return null;
                          }),
                          SizedBox(height: 16.h),
                          _buildlabelLarge(
                              l10n.email, _emailController,
                              TextInputType.emailAddress, (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.pleaseEnterEmail;
                            }
                            if (!value.contains('@') ||
                                !value.contains('.com')) {
                              return l10n.pleaseEnterValidEmail;
                            }
                            return null;
                          }),
                          SizedBox(height: 16.h),
                          _buildPasswordField(_passwordController, (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.pleaseEnterPassword;
                            }
                            if (!value.contains(RegExp(r'[0-9]'))) {
                              return l10n.passwordMinNumber;
                            }
                            return null;
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 60.h),
                    _isLoading
                        ? const CircularProgressIndicator(
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
                            _controller
                                .signUp(
                              fullName: _fullNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              context: context,
                            )
                                .whenComplete(() {
                              if (mounted) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
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
                          l10n.signUp,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.alreadyHaveAnAccount,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoute.logIn);
                          },
                          child: Text(
                            l10n.logIn,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
        errorBorder:
        const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        labelStyle: Theme.of(context).textTheme.labelLarge,
        filled: true,
        fillColor: const Color(0x1A6BB5B8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller,
      String? Function(String?)? validator) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: l10n.password,
        errorStyle: const TextStyle(color: Colors.red),
        labelStyle: Theme.of(context).textTheme.labelLarge,
        filled: true,
        fillColor: const Color(0x1A6BB5B8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF6BB5B8),
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