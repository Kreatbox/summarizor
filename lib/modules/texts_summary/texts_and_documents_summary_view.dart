import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:summarizor/core/services/responsive.dart';
import '../../l10n/app_localizations.dart';

class TextsAndDocumentsSummaryView extends StatefulWidget {
  const TextsAndDocumentsSummaryView({super.key});

  @override
  State<TextsAndDocumentsSummaryView> createState() =>
      _TextsAndDocumentsSummaryViewState();
}

class _TextsAndDocumentsSummaryViewState
    extends State<TextsAndDocumentsSummaryView> {
  List<Map<String, String>> _summaries = [];
  String? _userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final user = await CacheManager().getUser();
    if (user != null && mounted) {
      setState(() {
        _userId = user.uid;
      });
      await _loadSummaries();
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadSummaries() async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final String userSummariesKey = 'generated_summaries_list_$_userId';
    final String? summariesJson = prefs.getString(userSummariesKey);

    if (summariesJson != null) {
      final List<dynamic> decodedList = json.decode(summariesJson);
      if (mounted) {
        setState(() {
          _summaries = decodedList
              .map((item) => Map<String, String>.from(item))
              .toList();
          _summaries.sort((a, b) => b['id']!.compareTo(a['id']!));
        });
      }
    } else if (mounted) {
      setState(() {
        _summaries = [];
      });
    }
  }

  Future<void> _saveSummaries() async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final String userSummariesKey = 'generated_summaries_list_$_userId';
    final String summariesJson = json.encode(_summaries);
    await prefs.setString(userSummariesKey, summariesJson);
  }

  void _showCustomDialog(
      {required String title,
        required String content,
        required IconData iconData,
        required Color iconColor}) {
    final l10n = AppLocalizations.of(context)!;
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

  void _showDeleteConfirmationDialog(String summaryId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          icon: Icon(Icons.warning_amber_rounded,
              color: Colors.red[700], size: 48),
          title: Text(l10n.confirmDeletion, textAlign: TextAlign.center),
          content:
          Text(l10n.confirmDeleteSummaryMessage, textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child:
              Text(l10n.delete, style: const TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteSummary(summaryId);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteSummary(String id) {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _summaries.removeWhere((summary) => summary['id'] == id);
    });
    _saveSummaries();
    _showCustomDialog(
        title: l10n.deleted,
        content: l10n.summaryDeletedSuccess,
        iconData: Icons.check_circle_outline_rounded,
        iconColor: Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.savedSummaries,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _summaries.isEmpty
          ? Center(
        child: Padding(
          padding: 24.0.p,
          child: Text(
            l10n.noSummariesSaved,
            style:
            TextStyle(fontSize: 18.f, color: Colors.blueGrey),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : ListView.builder(
        padding: 10.0.p,
        itemCount: _summaries.length,
        itemBuilder: (context, index) {
          final summary = _summaries[index];
          final summaryNumber = _summaries.length - index;
          return Card(
            margin: 8.0.pv,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.8),
                child: Text(
                  '$summaryNumber',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                l10n.summaryNumber(summaryNumber),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              childrenPadding:
              EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0.h),
                  child: Text(
                    summary['content']!,
                    style: TextStyle(
                        fontSize: 16.f,
                        height: 1.5,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.copy,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: summary['content']!));
                          _showCustomDialog(
                              title: l10n.copied,
                              content: l10n.summaryCopiedSuccess,
                              iconData: Icons.copy_all_rounded,
                              iconColor: AppColors.primary);
                        },
                        tooltip: l10n.copySummary,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline,
                            color: Colors.red[600]),
                        onPressed: () => _showDeleteConfirmationDialog(
                            summary['id']!),
                        tooltip: l10n.deleteThisSummary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}