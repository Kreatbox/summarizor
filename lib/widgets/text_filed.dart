import 'package:flutter/material.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/services/responsive.dart';
class TextFiledApp extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Color color;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorMessage;
  final String? Function(String?)? validator;
  final double pt;
  final double pb;
  final double pl;
  final double pr;
  final double width;
  final double height;
  const TextFiledApp({super.key,
    required this.controller,
    required this.hintText,
    // required this.text,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.color = AppColors.primary,
    this.pt = 0,
    this.pb = 0,
    this.pl = 0,
    this.pr = 0,
    this.errorMessage,
    this.width = 327,
    this.height = 85,});


  @override
  State<TextFiledApp> createState() => _TextFiledState();
}

class _TextFiledState extends State<TextFiledApp> {

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.pt, left: widget.pl, right: widget.pr, bottom: widget.pb),
      child: SizedBox(
        height: widget.height.h,
        width: widget.width.w,
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          validator: widget.validator,
          cursorColor: widget.color,
          style: Theme.of(context).textTheme.labelLarge,
          decoration: InputDecoration(
            errorText: widget.errorMessage,
            errorStyle: Theme.of(context).textTheme.labelLarge,
            helperText: ' ',
            helperStyle: Theme.of(context).textTheme.labelLarge,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: widget.color),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: widget.color),
            ),
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(color:  AppColors.lightGrey,fontWeight: FontWeight.w400),
            prefixIcon:widget.prefixIcon != null ? Padding(
              padding:  EdgeInsets.only(left: 16.0.w ,right: 10.w),
              child: widget.prefixIcon,
            ):null ,
            prefixIconConstraints:BoxConstraints(
              minHeight: 24.h,
              minWidth: 24.w,
            ),
            suffixIconConstraints: BoxConstraints(
              minHeight: 40.h,
              minWidth: 40.w,
            ),
            suffixIcon: widget.suffixIcon != null
                ? InkWell(
              child: Icon(
                _obscureText
                    ? Icons.visibility
                    : Icons.visibility_off,
                size: 25.0.f,
              ),
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
        ),
      ),

    );
  }
}

