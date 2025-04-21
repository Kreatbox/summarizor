import 'package:flutter/material.dart';
import 'package:summarizor/core/constants/app_routes.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:summarizor/core/services/responsive.dart';
import 'package:summarizor/core/constants/app_images.dart';
import '../../core/services/navigation.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? fullName;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

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
                Images.sidebarIcon,
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
                  'Hello, ${fullName ?? ''}!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
          Image.asset(Images.placeholderImage, fit: BoxFit.cover, width: 412),
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: ListView(
              children: [
                Text(
                  'Hello',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  '${fullName ?? ''}!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 30.h),
                GestureDetector(
                  onTap: () {
                    Navigation.navigateTo( context, AppRoute.summarize);
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
                          Images.summarizeIcon,
                          height: 109.h,
                          width: 110.w,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Summraize A Document',
                          style:Theme.of(context).textTheme.headlineSmall
                        ),
                      ],
                    ),
                  ),
                ),

                // زر Create a Quiz
                GestureDetector(
                  onTap: () {
                    Navigation.navigateTo( context, AppRoute.quiz);
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
                          Images.quizIcon,
                          height: 110.h,
                          width: 125.w,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Create A Quiz',
                          style:Theme.of(context).textTheme.headlineSmall
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
  _loadUserData() async {
    final cacheManager = CacheManager();
    final user = await cacheManager.getUser();
    setState(() {
      fullName = user.fullName;
    });
  }
}
