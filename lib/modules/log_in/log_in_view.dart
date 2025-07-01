import 'package:flutter/material.dart';
import 'package:summarizor/modules/log_in/log_in_controller.dart';
import '../../core/constants/app_images.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/services/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';

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

  void _showCustomDialog({
    required String title,
    required String content,
    required IconData iconData,
    required Color iconColor,
    VoidCallback? onOkPressed,
  }) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          icon: Icon(iconData, color: iconColor, size: 48),
          title: Text(title, textAlign: TextAlign.center),
          content: Text(content, textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(l10n.ok, style: const TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                if (onOkPressed != null) {
                  onOkPressed();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final userToken = await _controller.login(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );
        if (userToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_token', userToken);
          if (!mounted) return;

          final l10n = AppLocalizations.of(context)!;
          _showCustomDialog(
            title: l10n.loginSuccess,
            content: l10n.welcomeBack,
            iconData: Icons.check_circle_outline_rounded,
            iconColor: Colors.green,
            onOkPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          );
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          _showCustomDialog(
            title: l10n.loginFailed,
            content: e.toString(),
            iconData: Icons.error_outline_rounded,
            iconColor: Colors.red,
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              padding: 20.ph + 30.pv,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      Images.appIcon,
                      width: 93.w,
                      height: 102.h,
                    ),
                    SizedBox(height: 60.h),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildEmailField(_emailController, l10n),
                          SizedBox(height: 16.h),
                          _buildPasswordField(_passwordController, l10n),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                    _isLoading
                        ? const CircularProgressIndicator(
                        color: AppColors.primary)
                        : SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          l10n.logIn,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.dontHaveAnAccount),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/signup");
                          },
                          child: Text(
                            l10n.signUp,
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

  Widget _buildEmailField(
      TextEditingController controller, AppLocalizations l10n) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.red),
        labelText: l10n.email,
        labelStyle: Theme.of(context).textTheme.labelLarge,
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red)),
        filled: true,
        fillColor: const Color(0x1A6BB5B8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterEmail;
        }
        if (!value.contains('@') || !value.contains('.com')) {
          return l10n.pleaseEnterValidEmail;
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller, AppLocalizations l10n) {
    return TextFormField(
      controller: controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.red),
        labelText: l10n.password,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterPassword;
        }
        return null;
      },
    );
  }
}