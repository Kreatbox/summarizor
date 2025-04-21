import 'package:flutter/material.dart';
import 'package:summarizor/core/services/responsive.dart';

import '../../core/constants/app_images.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding:EdgeInsets.only(left: 10.w, right: 10.w),
        child: ListView(
          children: [
            Image.asset(Images.quizIcon),
          ],
        ),),
    );
  }
}