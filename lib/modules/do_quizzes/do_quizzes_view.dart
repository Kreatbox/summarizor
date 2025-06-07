import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/modules/do_quizzes/take_quiz_screen.dart';
class DoQuizzesView extends StatefulWidget {
  const DoQuizzesView({super.key});

  @override
  State<DoQuizzesView> createState() => _DoQuizzesViewState();
}

class _DoQuizzesViewState extends State<DoQuizzesView> {
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
      setState(() {
        _quizzes = decodedList.map((item) => Map<String, String>.from(item)).toList();
        _quizzes.sort((a, b) => a['id']!.compareTo(b['id']!));
      });
    } else {
      setState(() {
        _quizzes = [];
      });
    }
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
        title: const Text("Available Quizzes"),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _quizzes.isEmpty
          ? const Center(
        child: Text(
          'No quizzes available to take. Create some first!',
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
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                'Quiz ${index + 1}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              subtitle: const Text('Tap to start this quiz.'),
              trailing: IconButton(
                icon: Icon(Icons.delete_forever, color: Colors.red[700]),
                onPressed: () => _deleteQuiz(quiz['id']!),
                tooltip: 'Delete this quiz',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakeQuizScreen(quizContent: quiz['content']!),
                  ),
                ).then((_) {
                  _loadQuizzes();
                });
              },
            ),
          );
        },
      ),
    );
  }
}