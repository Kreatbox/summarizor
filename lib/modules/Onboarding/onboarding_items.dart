import 'package:flutter/material.dart';
import 'onboarding_info.dart';
import 'package:summarizor/core/constants/app_images.dart';
import '../../l10n/app_localizations.dart';

class OnboardingItems {
  List<OnboardingInfo> getItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      OnboardingInfo(
          title1: l10n.onboarding1Title1,
          title2: l10n.onboarding1Title2,
          description: l10n.onboarding1Desc,
          image: Images.onboardingStep1),
      OnboardingInfo(
          title1: l10n.onboarding2Title1,
          title2: l10n.onboarding2Title2,
          description: l10n.onboarding2Desc,
          image: Images.onboardingStep2),
      OnboardingInfo(
          title1: l10n.onboarding3Title1,
          title2: l10n.onboarding3Title2,
          description: l10n.onboarding3Desc,
          image: Images.onboardingStep3)
    ];
  }
}