import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:summarizor/modules/do_quizzes/take_quiz_screen.dart';

class SummaryQuizzesView extends StatefulWidget {
  const SummaryQuizzesView({super.key});

  @override
  State<SummaryQuizzesView> createState() => _SummaryQuizzesViewState();
}

class _SummaryQuizzesViewState extends State<SummaryQuizzesView> {
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
      final List<dynamic> validQuizzes = decodedList.where((quiz) {
        return quiz is Map<String, dynamic> &&
            quiz.containsKey('quizData') &&
            quiz['quizData'] != null;
      }).toList();

      setState(() {
        _quizzes = validQuizzes;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Quizzes", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _quizzes.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'No quizzes generated yet for this account.',
            style: TextStyle(fontSize: 18, color: Colors.blueGrey),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _quizzes.length,
        itemBuilder: (context, index) {
          final quiz = _quizzes[index];
          final quizData = quiz['quizData'] as Map<String, dynamic>;
          final questions = quizData['questions'] as List<dynamic>;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                'Quiz Summary (${questions.length} Questions)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(questions.length, (qIndex) {
                      final question =
                      questions[qIndex] as Map<String, dynamic>;
                      final options = question['options'] as List<dynamic>;
                      final correctAnswer =
                      question['correctAnswer'] as String;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Q${qIndex + 1}: ${question['question']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(options.length, (optIndex) {
                              final option = options[optIndex] as String;
                              final String optionKey =
                              (question['type'] == 'multipleChoice')
                                  ? option.split(')').first.trim()
                                  : option;
                              final bool isCorrect =
                              (optionKey == correctAnswer);

                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 4.0),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isCorrect
                                        ? Colors.green[800]
                                        : Colors.black54,
                                    fontWeight: isCorrect
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_note, color: Colors.blue[700]),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(

                              builder: (context) => TakeQuizScreen(
                                quizData: quiz['quizData'] as Map<String, dynamic>,
                                quizId: quiz['id'] as String,
                              ),
                            ),
                          ).then((_) {
                            _loadQuizzes();
                          });
                        },
                        tooltip: 'Take Quiz',
                      ),
                      IconButton(
                        icon: Icon(Icons.copy,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          final StringBuffer buffer = StringBuffer();
                          for (var i = 0;
                          i < questions.length;
                          i++) {
                            final q =
                            questions[i] as Map<String, dynamic>;
                            buffer.writeln(
                                'Q${i + 1}: ${q['question']}');
                            final opts = q['options'] as List<dynamic>;
                            for (final option in opts) {
                              buffer.writeln('- $option');
                            }
                            buffer.writeln(
                                'Correct Answer: ${q['correctAnswer']}');
                            buffer.writeln();
                          }
                          Clipboard.setData(
                              ClipboardData(text: buffer.toString()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                Text('Quiz copied to clipboard!')),
                          );
                        },
                        tooltip: 'Copy Quiz Summary',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_forever,
                            color: Colors.red[700]),
                        onPressed: () =>
                            _deleteQuiz(quiz['id'] as String),
                        tooltip: 'Delete this quiz',
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