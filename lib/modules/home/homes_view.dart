import 'package:flutter/material.dart';
import 'package:summarizor/core/constants/app_colors.dart';
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
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final cacheManager = CacheManager();
    final user = await cacheManager.getUser();
    if (user != null && mounted) {
      setState(() {
        fullName = user.fullName;
        email = user.email;
      });
    }
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) {
      return '?';
    }
    List<String> names = name.split(" ");
    String initials = "";
    if (names.isNotEmpty) {
      initials += names[0][0];
      if (names.length > 1) {
        initials += names[names.length - 1][0];
      }
    }
    return initials.toUpperCase();
  }

  Future<void> _logout() async {
    final cacheManager = CacheManager();
    await cacheManager.logout();
    if (mounted) {
      Navigation.navigateAndRemove(context, AppRoute.logIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25.r),
            bottomRight: Radius.circular(25.r),
          ),
        ),
        child: DividerTheme(
          data: DividerThemeData(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
            thickness: 1,
          ),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  fullName ?? "Guest User",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.f),
                ),
                accountEmail: Text(email ?? ""),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(
                    _getInitials(fullName),
                    style: TextStyle(fontSize: 24.0.f, color: AppColors.primary),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('Summarize Text or File'),
                      onTap: () {
                        Navigation.pop_(context);
                        Navigation.navigateTo(context, AppRoute.summarize);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.quiz),
                      title: const Text('Create a Quiz'),
                      onTap: () {
                        Navigation.pop_(context);
                        Navigation.navigateTo(context, AppRoute.quiz);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.article),
                      title: const Text('Texts and Documents Summary'),
                      onTap: () {
                        Navigation.pop_(context);
                        Navigation.navigateTo(context, AppRoute.textsSummary);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.list_alt),
                      title: const Text('Summary Quizzes'),
                      onTap: () {
                        Navigation.pop_(context);
                        Navigation.navigateTo(context, AppRoute.summaryQuizzes);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.check_circle_outline),
                      title: const Text('Do the Quizzes'),
                      onTap: () {
                        Navigation.pop_(context);
                        Navigation.navigateTo(context, AppRoute.doQuizzes);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoute.settings)
                            .then((_) {
                          _loadUserData();
                        });
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title:
                const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: _logout,
              ),
              Padding(
                padding: only(bottom: 16),
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12.f),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(Images.placeholderImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: ListView(
              children: [
                Text(
                  'Hello,',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  '${fullName ?? ''}!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 30.h),
                GestureDetector(
                  onTap: () {
                    Navigation.navigateTo(context, AppRoute.summarize);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkGrey
                          : const Color(0xFFEFF7F6),
                      borderRadius: BorderRadius.circular(16.r),
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
                          'Summarize Text or File',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigation.navigateTo(context, AppRoute.quiz);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkGrey
                          : const Color(0xFFEFF7F6),
                      borderRadius: BorderRadius.circular(16.r),
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
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}