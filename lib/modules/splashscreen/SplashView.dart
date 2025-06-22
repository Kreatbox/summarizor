import 'package:flutter/material.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:summarizor/core/constants/app_routes.dart';
import 'package:summarizor/core/services/navigation.dart';
import 'package:summarizor/core/services/responsive.dart';

import '../../core/constants/app_images.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final CacheManager cacheManager = CacheManager();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final user = await cacheManager.getUser();
    if (user != null) {
      Navigation.navigateAndRemove(context, AppRoute.home);
    } else {
      Navigation.navigateAndRemove(context, AppRoute.logIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
            Images.logo,
              width: 120.w,
              height: 120.h,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
