import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summarizor/core/constants/app_colors.dart';


class SummaryQuizzesView extends StatefulWidget {
  final String? newQuizContent;

  const SummaryQuizzesView({super.key, this.newQuizContent});

  @override
  State<SummaryQuizzesView> createState() => _SummaryQuizzesViewState();
}

class _SummaryQuizzesViewState extends State<SummaryQuizzesView> {
  List<Map<String, String>> _quizzes = [];
  final String _quizzesKey = 'generated_quizzes_list';

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? quizzesJson = prefs.getString(_quizzesKey);

    if (quizzesJson != null) {
      final List<dynamic> decodedList = json.decode(quizzesJson);
      _quizzes = decodedList.map((item) => Map<String, String>.from(item)).toList();
    } else {
      final String? singleQuizText = prefs.getString('generated_quiz');
      if (singleQuizText != null && singleQuizText != "No quiz found.") {
        _quizzes.add({'id': DateTime.now().millisecondsSinceEpoch.toString(), 'content': singleQuizText});
        await prefs.remove('generated_quiz');
      }
    }
    setState(() {
      _quizzes.sort((a, b) => a['id']!.compareTo(b['id']!));
    });
  }

  void _deleteQuiz(String id) {
    setState(() {
      _quizzes.removeWhere((quiz) => quiz['id'] == id);
    });
    _saveQuizzes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quiz deleted successfully!')),
    );
  }

  Future<void> _saveQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    final String quizzesJson = json.encode(_quizzes);
    await prefs.setString(_quizzesKey, quizzesJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generated Quizzes"),
        backgroundColor: AppColors.primary,
      ),
      body: _quizzes.isEmpty
          ? const Center(
        child: Text(
          'No quizzes generated yet. Start creating some!',
          style: TextStyle(fontSize: 18, color: Colors.blueGrey),
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _quizzes.length,
        itemBuilder: (context, index) {
          final quiz = _quizzes[index];
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
                'Quiz Summary ${index + 1}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              childrenPadding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  quiz['content']!,
                  style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.delete_forever, color: Colors.red[700], size: 28),
                    onPressed: () => _deleteQuiz(quiz['id']!),
                    tooltip: 'Delete this quiz',
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