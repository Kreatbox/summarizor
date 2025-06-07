import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:summarizor/core/constants/app_colors.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    _isDarkModeEnabled = Theme.of(context).scaffoldBackgroundColor == Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          _buildSettingsTile(
            context,
            icon: Icons.light_mode,
            title: "Dark Mode",
            trailingWidget: Switch(
              value: _isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _isDarkModeEnabled = value;
                });
              },
              activeColor: AppColors.primary,
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.share,
            title: "Share",
            onTap: _shareApp,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        Widget? trailingWidget,
        VoidCallback? onTap,
      }) {
    final bool isDarkMode = Theme.of(context).scaffoldBackgroundColor == Colors.black;
    final Color textColor = isDarkMode ? Colors.white : AppColors.grey;
    final Color iconColor = isDarkMode ? AppColors.primary : AppColors.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkGrey : Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: isDarkMode
            ? []
            : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor,
                    ),
                  ),
                ),
                if (trailingWidget != null) trailingWidget,
                if (trailingWidget == null && onTap != null)
                  Icon(Icons.arrow_forward_ios, size: 18, color: textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _shareApp() {
    Share.share('Check out my amazing app! [App Download Link Here]');
  }
}