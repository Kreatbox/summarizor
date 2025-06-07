import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summarizor/core/constants/app_colors.dart';

class TextsAndDocumentsSummaryView extends StatefulWidget {
  const TextsAndDocumentsSummaryView({super.key});

  @override
  State<TextsAndDocumentsSummaryView> createState() =>
      _TextsAndDocumentsSummaryViewState();
}

class _TextsAndDocumentsSummaryViewState
    extends State<TextsAndDocumentsSummaryView> {
  List<Map<String, String>> _summaries = [];
  final String _summariesKey = 'generated_summaries_list';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSummaries();
  }

  Future<void> _loadSummaries() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final String? summariesJson = prefs.getString(_summariesKey);

    if (summariesJson != null) {
      final List<dynamic> decodedList = json.decode(summariesJson);
      _summaries =
          decodedList.map((item) => Map<String, String>.from(item)).toList();
      _summaries.sort((a, b) => b['id']!.compareTo(a['id']!));
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveSummaries() async {
    final prefs = await SharedPreferences.getInstance();
    final String summariesJson = json.encode(_summaries);
    await prefs.setString(_summariesKey, summariesJson);
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
        title: const Text("Saved Summaries"),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _summaries.isEmpty
          ? const Center(
        child: Text(
          'There are no summaries saved yet.',
          style: TextStyle(fontSize: 18, color: Colors.blueGrey),
          textAlign: TextAlign.center,
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
              const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                Text(
                  summary['content']!,
                  style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.delete_outline,
                        color: Colors.red[600]),
                    onPressed: () => _deleteSummary(summary['id']!),
                    tooltip: 'Delete this summary',
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