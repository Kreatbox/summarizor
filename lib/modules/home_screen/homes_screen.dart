import 'package:flutter/material.dart';
import 'package:summarizor/core/services/responsive.dart';
import 'package:summarizor/core/constants/images.dart';
import 'package:summarizor/modules/summarize/summarize.dart';
import '../../core/constants/text_style.dart';
import '../../core/services/navigation.dart';
import 'package:summarizor/modules/create_quiz/create_quiz.dart';
class HomesScreen extends StatefulWidget {
  const HomesScreen({super.key});

  @override
  State<HomesScreen> createState() => _HomesScreenState();
}

class _HomesScreenState extends State<HomesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Image.asset(
                Images.sidebar,
                width: 50.w,
                height: 50.h,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Text(
                  'Hello, Leena!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),

              ListTile(
                leading: Icon(Icons.description),
                title: Text('Summarize a Document'),
                onTap: () {
                 Navigation.pop_(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.quiz),
                title: Text('Create a Quiz'),
                onTap: () {
                  Navigation.pop_(context);
                },
              ),
            ],
          ),
        ),
        body: Stack(children: [
          Image.asset(Images.base3, fit: BoxFit.cover, width: 412),
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: ListView(
              children: [
                Text(
                  'Hello',
                  style: TextFormStyle.appbar,
                ),
                Text(
                  'Leena!',
                  style: TextFormStyle.appbar2,
                ),
                SizedBox(height: 30.h),
                GestureDetector(
                  onTap: () {
                    Navigation.navigateTo( context, summarize());
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF7F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          Images.summarizeImage,
                          height: 109.h,
                          width: 110.w,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Summraize A Document',
                          style:TextFormStyle.homebox
                        ),
                      ],
                    ),
                  ),
                ),

                // زر Create a Quiz
                GestureDetector(
                  onTap: () {
                    Navigation.navigateTo( context,CreateQuiz() );
                  },
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF7F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          Images.quizImage,
                          height: 110.h,
                          width: 125.w,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Create A Quiz',
                          style:TextFormStyle.homebox
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}
