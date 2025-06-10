import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/services/cache_manager.dart';

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
    setState(() => _isLoading = false);
  }

  Future<void> _loadSummaries() async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final String userSummariesKey = 'generated_summaries_list_$_userId';
    final String? summariesJson = prefs.getString(userSummariesKey);

    if (summariesJson != null) {
      final List<dynamic> decodedList = json.decode(summariesJson);
      _summaries =
          decodedList.map((item) => Map<String, String>.from(item)).toList();
      _summaries.sort((a, b) => b['id']!.compareTo(a['id']!));
    }
    else {
      _summaries = [];
    }
  }

  Future<void> _saveSummaries() async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final String userSummariesKey = 'generated_summaries_list_$_userId';
    final String summariesJson = json.encode(_summaries);
    await prefs.setString(userSummariesKey, summariesJson);
  }

  void _deleteSummary(String id) {
    setState(() {
      _summaries.removeWhere((summary) => summary['id'] == id);
    });
    _saveSummaries();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Summary deleted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Summaries", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _summaries.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'There are no summaries saved for this account yet.',
            style: TextStyle(fontSize: 18, color: Colors.blueGrey),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: _summaries.length,
        itemBuilder: (context, index) {
          final summary = _summaries[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.8),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                'Summary #${_summaries.length - index}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              childrenPadding:
              const EdgeInsets.fromLTRB(16, 0, 16, 8),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    summary['content']!,
                    style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.copy, color: Theme.of(context).primaryColor),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: summary['content']!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Summary copied to clipboard!')),
                          );
                        },
                        tooltip: 'Copy Summary',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red[600]),
                        onPressed: () => _deleteSummary(summary['id']!),
                        tooltip: 'Delete this summary',
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