import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:summarizor/modules/do_quizzes/take_quiz_screen.dart';
import 'package:summarizor/core/services/responsive.dart';

class DoQuizzesView extends StatefulWidget {
  const DoQuizzesView({super.key});

  @override
  State<DoQuizzesView> createState() => _DoQuizzesViewState();
}

class _DoQuizzesViewState extends State<DoQuizzesView> {
  List<dynamic> _quizzes = [];
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await CacheManager().getUser();
    if (user != null && mounted) {
      setState(() {
        _userId = user.uid;
      });
      _loadQuizzes();
    }
  }

  Future<void> _loadQuizzes() async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final String userQuizzesKey = 'generated_quizzes_list_$_userId';
    final String? quizzesJson = prefs.getString(userQuizzesKey);

    if (quizzesJson != null) {
      final List<dynamic> decodedList = json.decode(quizzesJson);
      setState(() {
        _quizzes = decodedList;
        _quizzes.sort((a, b) => (b['id'] as String).compareTo(a['id'] as String));
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
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final String userQuizzesKey = 'generated_quizzes_list_$_userId';
    await prefs.setString(userQuizzesKey, json.encode(_quizzes));
  }

  void _navigateToTakeQuiz(Map<String, dynamic> quizData, String quizId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakeQuizScreen(quizData: quizData, quizId: quizId),
      ),
    ).then((_) {
      _loadQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Quizzes", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _quizzes.isEmpty
          ?  Center(
        child: Padding(
          padding: 24.0.p,
          child: Text(
            'No quizzes available. Go to "Create Quiz" to make one!',
            style: TextStyle(fontSize: 18.f, color: Colors.blueGrey),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : ListView.builder(
        padding: 16.0.p,
        itemCount: _quizzes.length,
        itemBuilder: (context, index) {
          final quiz = _quizzes[index];
          final quizData = quiz['quizData'] as Map<String, dynamic>;
          final questions = quizData['questions'] as List<dynamic>;
          bool isCompleted = quiz['isCompleted'] ?? false;
          int correct = quiz['correctAnswers'] ?? 0;
          int wrong = quiz['wrongAnswers'] ?? 0;

          return Card(
            margin: 8.0.pv,
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
            child: ListTile(
              contentPadding: 10.pv + 15.ph,
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                'Quiz with ${questions.length} questions',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              subtitle: Text(
                isCompleted ? 'Completed: $correct correct, $wrong wrong' : 'Ready to take',
                style: TextStyle(
                  color: isCompleted ? (correct >= wrong ? Colors.green : Colors.red) : null,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompleted)
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.blue),
                      onPressed: () => _navigateToTakeQuiz(quiz['quizData'] as Map<String, dynamic>, quiz['id'] as String),
                      tooltip: 'Retake Quiz',
                    ),
                  IconButton(
                    icon: Icon(Icons.delete_forever, color: Colors.red[700]),
                    onPressed: () => _deleteQuiz(quiz['id'] as String),
                    tooltip: 'Delete this quiz',
                  ),
                ],
              ),
              onTap: () => _navigateToTakeQuiz(quiz['quizData'] as Map<String, dynamic>, quiz['id'] as String),
            ),
          );
        },
      ),
    );
  }
}