import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:summarizor/modules/log_in/log_in_view.dart';
import 'firebase_options.dart';
import 'package:summarizor/modules/Onboarding/onboarding_view.dart';
import 'package:summarizor/modules/signup/sign_up_view.dart';
import 'package:summarizor/core/services/responsive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: "/onboarding", 
      routes: {
        "/onboarding": (context) => const OnboardingView(),
        "/signup": (context) => const Signup(),
        "/log_in_view": (context) => const LogInView(), 
      },
    );
  }
}