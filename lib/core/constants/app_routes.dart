import 'package:flutter/material.dart';
import 'package:summarizor/modules/home/homes_view.dart';
import 'package:summarizor/modules/summarize/summarize_view.dart';
import 'package:summarizor/modules/log_in/log_in_view.dart';
import 'package:summarizor/modules/Onboarding/onboarding_view.dart';
import 'package:summarizor/modules/sign_up/sign_up_view.dart';
import 'package:summarizor/modules/quiz/quiz_view.dart';

class AppRoute {
  static const String onboarding = "/onboarding";
  static const String signUp = "/signup";
  static const String logIn = "/log_in_view";
  static const String summarize = "/summerize";
  static const String quiz = "/create_quiz";
  static const String home = "/home";


  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnboardingView(),
    signUp: (context) => SingUpView(),
    logIn: (context) => const LogInView(),
    summarize: (context) => const SummarizeView(),
    quiz: (context) => const QuizView(),
    home: (context) => const HomeView(),
  };
}
