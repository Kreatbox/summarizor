import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for Clipboard functionality
import 'package:provider/provider.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/constants/app_themes.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizor/core/services/responsive.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  void _showCustomDialog({
    required String title,
    required String content,
    required IconData iconData,
    required Color iconColor,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          icon: Icon(iconData, color: iconColor, size: 48),
          title: Text(title, textAlign: TextAlign.center),
          content: Text(content, textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditNameDialog() async {
    final cacheManager = CacheManager();
    final user = await cacheManager.getUser();
    _nameController.text = user?.fullName ?? '';

    if (!mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Please enter your new name.'),
                SizedBox(height: 16.h),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full Name',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            FilledButton(
              child: const Text('Save'),
              onPressed: () async {
                final newName = _nameController.text.trim();
                if (newName.isEmpty || user == null) {
                  return;
                }

                Navigator.of(dialogContext).pop();

                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update({'fullName': newName});

                  final updatedUser = user.copyWith(fullName: newName);
                  await cacheManager.saveUser(updatedUser);

                  if (mounted) {
                    _showCustomDialog(
                      title: 'Success',
                      content: 'Your name has been updated successfully.',
                      iconData: Icons.check_circle_outline_rounded,
                      iconColor: Colors.green,
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    _showCustomDialog(
                      title: 'Error',
                      content: 'Failed to update name. Please try again.',
                      iconData: Icons.error_outline_rounded,
                      iconColor: Colors.red,
                    );
                  }
                }
              },
            ),
          ],
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        );
      },
    );
  }

  // New function to copy the invitation message to the clipboard.
  void _copyInvitation() {
    const String invitationMessage =
        'We invite you to join the "Summarizor app" to learn more easily.';
    Clipboard.setData(const ClipboardData(text: invitationMessage)).then((_) {
      if (mounted) {
        _showCustomDialog(
            title: 'Copied!',
            content: 'The invitation message has been copied to your clipboard.',
            iconData: Icons.check_circle_outline_rounded,
            iconColor: Colors.green);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) {
        final isDarkMode = theme.themeMode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: isDarkMode ? AppColors.charcoal : Colors.white,
          appBar: AppBar(
            title: const Text("Settings"),
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20.f,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: ListView(
            children: [
              _buildSettingsTile(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.light_mode,
                title: "Dark Mode",
                trailingWidget: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    theme.setTheme(value ? ThemeMode.dark : ThemeMode.light);
                  },
                  activeColor: AppColors.primary,
                  inactiveThumbColor: Colors.grey[400],
                  inactiveTrackColor: Colors.grey[300],
                ),
              ),
              _buildSettingsTile(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.edit,
                title: "Edit Name",
                onTap: _showEditNameDialog,
              ),
              _buildSettingsTile(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.share,
                title: "share",
                onTap: _copyInvitation,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required bool isDarkMode,
    required IconData icon,
    required String title,
    Widget? trailingWidget,
    VoidCallback? onTap,
  }) {
    final Color textColor = isDarkMode ? Colors.white : AppColors.grey;
    final Color iconColor = AppColors.primary;

    return Container(
      margin: 16.0.ph + 8.0.pv,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkGrey : Colors.white,
        borderRadius: BorderRadius.circular(12.0.r),
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
          borderRadius: BorderRadius.circular(12.0.r),
          child: Padding(
            padding: 20.0.ph + 16.0.pv,
            child: Row(
              children: [
                Icon(icon, color: iconColor),
                SizedBox(width: 20.w),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
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



}
