import 'onboarding_info.dart';
import 'package:summarizor/core/constants/app_images.dart';

class OnboardingItems{
  List<OnboardingInfo> items = [
    OnboardingInfo(
        title1: "Welcome to",
        title2: "Summarizer",
        description: "Welcome to Summarizer app!"
            "Whether you're a student, teacher, our appmakes creating educational content simple and fast. ",
        image: Images.onboardingStep1),

    OnboardingInfo(
        title1: "Learn smarter",
        title2: "Not harder!",
        description: "With our summarization and question generation app, you can turn your text files or study materials into concise summaries and tailored questions effortlessly.",
        image: Images.onboardingStep2),

    OnboardingInfo(
        title1: "Experience",
        title2: "AI powerd!",
        description: "Start now by uploading your educational materials. We'll help you summarize them in minutes and create professional-level questions for effective review or testing.",
        image: Images.onboardingStep3)
  ];
}