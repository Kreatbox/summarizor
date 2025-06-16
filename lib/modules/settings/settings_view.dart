import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/constants/app_themes.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> _showEditNameDialog() async {
    final cacheManager = CacheManager();
    final user = await cacheManager.getUser();
    _nameController.text = user?.fullName ?? '';

    if (!mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Please enter your new name.'),
                const SizedBox(height: 16),
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
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              child: const Text('Save'),
              onPressed: () async {
                final newName = _nameController.text.trim();
                if (newName.isEmpty || user == null) {
                  return;
                }

                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update({'fullName': newName});

                  final updatedUser = user.copyWith(fullName: newName);
                  await cacheManager.saveUser(updatedUser);

                  if (mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("The name has been updated successfully")),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to update name. Please try again.")),
                    );
                  }
                }
              },
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) {
        final isDarkMode = theme.themeMode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            title: const Text("Settings"),
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
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
                title: "Share",
                onTap: _shareApp,
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
            padding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 20),
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

  void _shareApp() {
    Share.share('Check out Summarizor app! [Your App Link Here]');
  }
}
