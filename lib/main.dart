import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/constants/app_routes.dart';
import 'core/constants/app_themes.dart';
import 'firebase_options.dart';
import 'package:summarizor/core/services/responsive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
        return MyWidget(
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoute.onboarding,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      routes: AppRoute.routes, 
    ),);
  }
}