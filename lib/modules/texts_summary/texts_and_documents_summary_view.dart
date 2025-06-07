import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summarizor/core/constants/app_colors.dart';

class TextsAndDocumentsSummaryView extends StatefulWidget {
  final String? newSummaryContent;

  const TextsAndDocumentsSummaryView({super.key, this.newSummaryContent});

  @override
  State<TextsAndDocumentsSummaryView> createState() => _TextsAndDocumentsSummaryViewState();
}

class _TextsAndDocumentsSummaryViewState extends State<TextsAndDocumentsSummaryView> {
  List<Map<String, String>> _summaries = [];
  final String _summariesKey = 'generated_summaries_list';

  @override
  void initState() {
    super.initState();
    _loadSummaries();
  }

  Future<void> _loadSummaries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? summariesJson = prefs.getString(_summariesKey);

    if (summariesJson != null) {
      final List<dynamic> decodedList = json.decode(summariesJson);
      _summaries = decodedList.map((item) => Map<String, String>.from(item)).toList();
    }

    if (widget.newSummaryContent != null && widget.newSummaryContent!.isNotEmpty) {
      bool isDuplicate = _summaries.any((summary) => summary['content'] == widget.newSummaryContent);
      if (!isDuplicate) {
        _summaries.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': widget.newSummaryContent!
        });
      }
    }

    setState(() {
      _summaries.sort((a, b) => a['id']!.compareTo(b['id']!));
    });
    await _saveSummaries();
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
        title: const Text("Texts and Documents Summaries"),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: _summaries.isEmpty
          ? const Center(
        child: Text(
          'There are no summaries saved yet. Start generating some!',
          style: TextStyle(fontSize: 18, color: Colors.blueGrey),
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _summaries.length,
        itemBuilder: (context, index) {
          final summary = _summaries[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                'Summary ${index + 1}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              childrenPadding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  summary['content']!,
                  style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.delete_forever, color: Colors.red[700]),
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