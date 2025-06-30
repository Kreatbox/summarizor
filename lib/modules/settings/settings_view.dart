import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/constants/app_themes.dart';
import 'package:summarizor/core/providers/locale_provider.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summarizor/core/services/responsive.dart';

import '../../l10n/app_localizations.dart';

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
        final l10n = AppLocalizations.of(context)!;
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
              child: Text(l10n.ok, style: const TextStyle(color: Colors.white)),
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
    final l10n = AppLocalizations.of(context)!;
    final cacheManager = CacheManager();
    final user = await cacheManager.getUser();
    _nameController.text = user?.fullName ?? '';

    if (!mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.editNameTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(l10n.editNameContent),
                SizedBox(height: 16.h),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: l10n.fullName,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            FilledButton(
              child: Text(l10n.save),
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
                      title: l10n.success,
                      content: l10n.nameUpdatedSuccess,
                      iconData: Icons.check_circle_outline_rounded,
                      iconColor: Colors.green,
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    _showCustomDialog(
                      title: l10n.error,
                      content: l10n.nameUpdatedError,
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

  void _copyInvitation() {
    final l10n = AppLocalizations.of(context)!;
    final String invitationMessage = l10n.invitationMessage;
    Clipboard.setData(ClipboardData(text: invitationMessage)).then((_) {
      if (mounted) {
        _showCustomDialog(
            title: l10n.copied,
            content: l10n.invitationCopied,
            iconData: Icons.check_circle_outline_rounded,
            iconColor: Colors.green);
      }
    });
  }

  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text(l10n.selectLanguage),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text(l10n.english),
                    onTap: () {
                      localeProvider.setLocale(const Locale('en'));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(l10n.arabic),
                    onTap: () {
                      localeProvider.setLocale(const Locale('ar'));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) {
        final isDarkMode = theme.themeMode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: isDarkMode ? AppColors.charcoal : Colors.white,
          appBar: AppBar(
            title: Text(l10n.settings),
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
                icon: Icons.language,
                title: l10n.language,
                onTap: _showLanguageDialog,
              ),
              _buildSettingsTile(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.light_mode,
                title: l10n.darkMode,
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
                title: l10n.editName,
                onTap: _showEditNameDialog,
              ),
              _buildSettingsTile(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.share,
                title: l10n.share,
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