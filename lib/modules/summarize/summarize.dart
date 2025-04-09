import 'package:flutter/material.dart';
import 'package:summarizor/core/services/responsive.dart';

import '../../core/constants/images.dart';

class summarize extends StatefulWidget {
  const summarize({super.key});

  @override
  State<summarize> createState() => _summarizeState();
}

class _summarizeState extends State<summarize> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding:EdgeInsets.only(left: 10.w, right: 10.w),
      child: ListView(
        children: [
          Image.asset(Images.summarizeImage),
        ],
      ),),
    );
  }
}
