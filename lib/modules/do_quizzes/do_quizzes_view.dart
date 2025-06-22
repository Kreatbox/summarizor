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
      if (mounted) {
        setState(() {
          _quizzes = decodedList;
          _quizzes
              .sort((a, b) => (b['id'] as String).compareTo(a['id'] as String));
        });
      }
    } else if (mounted) {
      setState(() {
        _quizzes = [];
      });
    }
  }

  void _showCustomDialog(
      {required String title,
        required String content,
        required IconData iconData,
        required Color iconColor}) {
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

  void _showDeleteConfirmationDialog(String quizId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          icon: Icon(Icons.warning_amber_rounded,
              color: Colors.red[700], size: 48),
          title: const Text('Confirm Deletion', textAlign: TextAlign.center),
          content: const Text(
              'Are you sure you want to permanently delete this quiz?',
              textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteQuiz(quizId);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteQuiz(String id) {
    setState(() {
      _quizzes.removeWhere((quiz) => quiz['id'] == id);
    });
    _saveQuizzes();
    _showCustomDialog(
        title: 'Deleted',
        content: 'The quiz has been deleted successfully.',
        iconData: Icons.check_circle_outline_rounded,
        iconColor: Colors.green);
  }

  Future<void> _saveQuizzes() async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final String userQuizzesKey = 'generated_quizzes_list_$_userId';
    await prefs.setString(userQuizzesKey, json.encode(_quizzes));
  }

  void _navigateToTakeQuiz(Map<String, dynamic> quizData, String quizId) {
    if (_userId == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakeQuizScreen(
          quizData: quizData,
          quizId: quizId,
          userId: _userId!,
        ),
      ),
    ).then((_) {
      _loadQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Quizzes",
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _quizzes.isEmpty
          ? Center(
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
          if (quiz['quizData'] == null ||
              quiz['quizData']['questions'] == null) {
            return const SizedBox.shrink();
          }
          final quizData = quiz['quizData'] as Map<String, dynamic>;
          final questions = quizData['questions'] as List<dynamic>;
          bool isCompleted = quiz['isCompleted'] ?? false;
          int correct = quiz['correctAnswers'] ?? 0;
          int wrong = quiz['wrongAnswers'] ?? 0;

          return Card(
            margin: 8.0.pv,
            elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r)),
            child: ListTile(
              contentPadding: 10.pv + 15.ph,
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                'Quiz with ${questions.length} questions',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary),
              ),
              subtitle: isCompleted
                  ? RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: Colors.grey.shade600, fontSize: 14),
                  children: <TextSpan>[
                    const TextSpan(text: 'Result: '),
                    TextSpan(
                        text: '$correct correct',
                        style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500)),
                    const TextSpan(text: ', '),
                    TextSpan(
                        text: '$wrong wrong',
                        style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              )
                  : Text(
                'Not yet taken. Tap to start.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompleted)
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.blue),
                      onPressed: () => _navigateToTakeQuiz(
                          quiz['quizData'] as Map<String, dynamic>,
                          quiz['id'] as String),
                      tooltip: 'Retake Quiz',
                    ),
                  IconButton(
                    icon: Icon(Icons.delete_forever,
                        color: Colors.red[700]),
                    onPressed: () => _showDeleteConfirmationDialog(
                        quiz['id'] as String),
                    tooltip: 'Delete this quiz',
                  ),
                ],
              ),
              onTap: () => _navigateToTakeQuiz(
                  quiz['quizData'] as Map<String, dynamic>,
                  quiz['id'] as String),
            ),
          );
        },
      ),
    );
  }
}