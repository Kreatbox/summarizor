import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:summarizor/core/constants/route.dart';
import 'package:summarizor/modules/Onboarding/onboarding_items.dart';
import 'package:summarizor/core/services/responsive.dart';
import 'package:summarizor/core/constants/images.dart';
import 'package:summarizor/core/constants/text_style.dart';
import 'package:summarizor/core/services/navigation.dart';
import '../../core/constants/color.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller  = OnboardingItems();
  final pageContoller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 30.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SmoothPageIndicator(
              controller: pageContoller,
              count: controller.items.length,
              onDotClicked: (index)=> pageContoller.animateToPage(index,duration: const Duration(milliseconds: 600),
                  curve: Curves.easeIn),
              effect: const WormEffect(
                activeDotColor:  PrimaryColor
              ),
            ),
            SizedBox(width: 130.w,),
            ElevatedButton(
              onPressed: () {
                if (pageContoller.page == controller.items.length - 1) {
                  Navigation.navigateAndRemove(context, AppRoute.home);
                } else {
                  pageContoller.nextPage(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeIn,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 5,
              ),
              child: Text(
                pageContoller.hasClients && (pageContoller.page?.toInt() == controller.items.length - 1)
                    ? "Finish"
                    : "Next",style: TextFormStyle.textbutton,
              ),
            )

          ],
        ),
      ) ,
            body:
            SafeArea(
              child: PageView.builder(
                itemCount: controller.items.length,
                  controller: pageContoller,
                  itemBuilder: (context,index){
                  return Stack(
                    children: [
                      Image.asset(Images.onBoard,fit: BoxFit.cover,width: 412.w,
                       ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 80.h,
                          ),
                          child:  Text(controller.items[index].title1,
                            style: TextFormStyle.textObboardtitle1,),
                        ),
                        Text(controller.items[index].title2,
                          style: TextFormStyle.textObboardtitle2,
                          textAlign: TextAlign.center,),
                        Padding(
                          padding: EdgeInsets.only(top: 45.h,left: 20.w,right: 20.w),
                          child: Image.asset(controller.items[index].image,width: 364.w,height: 279.h,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h,left: 15.w,right: 15.w),
                          child:  Text(controller.items[index].description,
                            style: TextFormStyle.textObboardDesc,
                            textAlign: TextAlign.center,),
                        ),
                      ],
                    ),]
                  );
              }),
            ),

    );
  }
}
