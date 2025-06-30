import 'package:flutter/material.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/constants/app_routes.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:summarizor/core/services/responsive.dart';
import 'package:summarizor/core/constants/app_images.dart';
import '../../core/services/navigation.dart';
import '../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
                  fullName ?? l10n.guestUser,
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
                      title: Text(l10n.summarizeTextOrFile),
                      onTap: () {
                        Navigation.pop_(context);
                        Navigation.navigateTo(context, AppRoute.summarize);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.quiz),
                      title: Text(l10n.createAQuiz),
                      onTap: () {
                        Navigation.pop_(context);
                        Navigation.navigateTo(context, AppRoute.quiz);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.article),
                      title: Text(l10n.savedTextAndDocumentSummaries),
                      onTap: () {
                        Navigation.pop_(context);
                        Navigation.navigateTo(context, AppRoute.textsSummary);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.list_alt),
                      title: Text(l10n.savedSummaryQuizzes),
                      onTap: () {
                        Navigation.pop_(context);
                        Navigation.navigateTo(context, AppRoute.summaryQuizzes);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.check_circle_outline),
                      title: Text(l10n.doTheQuizzes),
                      onTap: () {
                        Navigation.pop_(context);
                        Navigation.navigateTo(context, AppRoute.doQuizzes);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(l10n.settings),
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
                Text(l10n.logout, style: const TextStyle(color: Colors.red)),
                onTap: _logout,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Text(
                  l10n.version,
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
                SizedBox(height: 100.h),
                Text(
                  l10n.hello,
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
                          l10n.summarizeTextOrFile,
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
                          l10n.createAQuiz,
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