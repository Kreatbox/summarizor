import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:summarizor/core/constants/app_routes.dart';
import 'package:summarizor/modules/Onboarding/onboarding_items.dart';
import 'package:summarizor/core/services/responsive.dart';
import 'package:summarizor/core/constants/app_images.dart';
import 'package:summarizor/core/services/navigation.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});
  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final pageController = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onboardingData = OnboardingItems();
    final items = onboardingData.getItems(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: Container(
        width: double.infinity,
        color: Colors.white,
        padding: 10.ph + 30.pv,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SmoothPageIndicator(
              controller: pageController,
              count: items.length,
              onDotClicked: (index) => pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeIn),
              effect: const WormEffect(activeDotColor: AppColors.primary),
            ),
            SizedBox(width: 150.w),
            ElevatedButton(
              onPressed: () {
                if (isLastPage) {
                  Navigation.navigateAndRemove(context, AppRoute.signUp);
                } else {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeIn,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 5,
              ),
              child: Text(
                isLastPage ? l10n.finish : l10n.next,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: PageView.builder(
            itemCount: items.length,
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == items.length - 1;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Image.asset(Images.onboardingBackground,
                      fit: BoxFit.cover, width: 412.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: only(
                          top: 5.h,
                        ),
                        child: Text(
                          items[index].title1,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                      Text(
                        items[index].title2,
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding:
                        only(top: 45.h, left: 20.w, right: 20.w),
                        child: Image.asset(
                          items[index].image,
                          width: 364.w,
                          height: 279.h,
                        ),
                      ),
                      Padding(
                        padding:
                        only(top: 20.h, left: 15.w, right: 15.w),
                        child: Text(
                          items[index].description,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}