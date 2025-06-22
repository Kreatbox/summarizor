import 'package:flutter/material.dart';

import 'package:summarizor/modules/Onboarding/onboarding_view.dart';
import 'package:summarizor/modules/sign_up/sign_up_view.dart';
import 'package:summarizor/modules/log_in/log_in_view.dart';
import 'package:summarizor/modules/home/homes_view.dart';
import 'package:summarizor/modules/summarize/summarize_view.dart';
import 'package:summarizor/modules/quiz/quiz_view.dart';
import 'package:summarizor/modules/texts_summary/texts_and_documents_summary_view.dart';
import 'package:summarizor/modules/summary_quizzes/summary_quizzes_view.dart';
import 'package:summarizor/modules/do_quizzes/do_quizzes_view.dart';
import 'package:summarizor/modules/settings/settings_view.dart';
import 'package:summarizor/modules/splashscreen/SplashView.dart';

class AppRoute {
  static const String onboarding = "/onboarding";
  static const String signUp = "/signup";
  static const String logIn = "/log_in_view";
  static const String home = "/home";
  static const String summarize = "/summarize";
  static const String quiz = "/create_quiz";
  static const String textsSummary = "/texts_summary";
  static const String summaryQuizzes = "/summary_quizzes";
  static const String doQuizzes = "/do_quizzes";
  static const String takeQuiz = "/take_quiz";
  static const String splash = "/splash";



  static const String settings = "/settings";

  static final Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnboardingView(),
    signUp: (context) => SingUpView(),
    logIn: (context) => const LogInView(),
    home: (context) => const HomeView(),
    summarize: (context) => const SummarizeView(),
    quiz: (context) => const QuizView(),
    textsSummary: (context) => const TextsAndDocumentsSummaryView(),
    summaryQuizzes: (context) => const SummaryQuizzesView(),
    doQuizzes: (context) => const DoQuizzesView(),
    settings: (context) => const SettingsView(),
    splash: (context) => const SplashView(),
  };
}