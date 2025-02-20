import 'package:flutter/material.dart';
import 'package:summarizor/core/services/responsive.dart';
import '../../core/constants/images.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              Image.asset(Images.base,fit: BoxFit.cover,width: 412.w,
              ),


        ],
      ))
    );
  }
}
