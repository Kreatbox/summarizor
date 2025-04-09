import 'package:flutter/material.dart';
import 'package:summarizor/core/services/responsive.dart';

import '../../core/constants/images.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key});

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding:EdgeInsets.only(left: 10.w, right: 10.w),
        child: ListView(
          children: [
            Image.asset(Images.quizImage),
          ],
        ),),
    );
  }
}