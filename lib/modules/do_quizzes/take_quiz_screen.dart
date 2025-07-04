import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/models/quiz_model.dart';
import 'package:summarizor/core/services/responsive.dart';
import '../../l10n/app_localizations.dart';

class TakeQuizScreen extends StatefulWidget {
  final Map<String, dynamic> quizData;
  final String quizId;
  final String userId;

  const TakeQuizScreen({
    super.key,
    required this.quizData,
    required this.quizId,
    required this.userId,
  });

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  List<QuizQuestion> _questions = [];
  final Map<int, String> _selectedAnswers = {};
  bool _quizSubmitted = false;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestionsFromJson();
  }

  void _loadQuestionsFromJson() {
    List<dynamic> questionsJson = widget.quizData['questions'] ?? [];
    setState(() {
      _questions = questionsJson.map((q) => QuizQuestion.fromJson(q)).toList();
    });
  }

  void _showCustomDialog({
    required String title,
    required String content,
    required IconData iconData,
    required Color iconColor,
  }) {
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

  Future<void> _saveQuizResults() async {
    final prefs = await SharedPreferences.getInstance();
    final String quizzesKey = 'generated_quizzes_list_${widget.userId}';
    final String? quizzesJson = prefs.getString(quizzesKey);
    List<dynamic> currentQuizzes = [];

    if (quizzesJson != null) {
      currentQuizzes = json.decode(quizzesJson);
    }

    int quizIndex = currentQuizzes.indexWhere((q) => q['id'] == widget.quizId);
    if (quizIndex != -1) {
      currentQuizzes[quizIndex]['isCompleted'] = true;
      currentQuizzes[quizIndex]['correctAnswers'] = _correctAnswers;
      currentQuizzes[quizIndex]['wrongAnswers'] = _wrongAnswers;
      await prefs.setString(quizzesKey, json.encode(currentQuizzes));
    }
  }

  void _submitQuiz() {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedAnswers.length != _questions.length) {
      _showCustomDialog(
          title: l10n.incompleteQuiz,
          content: l10n.pleaseAnswerAllQuestions,
          iconData: Icons.warning_amber_rounded,
          iconColor: Colors.orange);
      return;
    }

    int correct = 0;
    for (int i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final selectedAnswer = _selectedAnswers[i];

      String selectedKey = selectedAnswer!;
      if (question.type == QuestionType.multipleChoice) {
        selectedKey = selectedAnswer.split(')').first.trim();
      }

      if (selectedKey == question.correctAnswer) {
        correct++;
      }
    }

    setState(() {
      _quizSubmitted = true;
      _correctAnswers = correct;
      _wrongAnswers = _questions.length - correct;
    });
  }

  Color _getOptionColor(int questionIndex, String option) {
    if (!_quizSubmitted) return Colors.black;

    final question = _questions[questionIndex];
    final selectedAnswer = _selectedAnswers[questionIndex];

    String optionKey = option;
    String correctKey = question.correctAnswer;
    if (question.type == QuestionType.multipleChoice) {
      optionKey = option.split(')').first.trim();
    }

    if (optionKey == correctKey) {
      return Colors.green;
    } else if (option == selectedAnswer && optionKey != correctKey) {
      return Colors.red;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.takeQuiz, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: 16.0.p,
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return Card(
                  margin: 10.0.pv,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  child: Padding(
                    padding: 16.0.p,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10n.question(index + 1)}: ${question.question}',
                          style: TextStyle(
                              fontSize: 18.f, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15.h),
                        ...question.options.map((option) {
                          return Padding(
                            padding: 4.0.pv,
                            child: RadioListTile<String>(
                              title: Text(
                                option,
                                style: TextStyle(
                                    color: _getOptionColor(index, option)),
                              ),
                              value: option,
                              groupValue: _selectedAnswers[index],
                              onChanged: _quizSubmitted
                                  ? null
                                  : (value) {
                                setState(() {
                                  _selectedAnswers[index] = value!;
                                });
                              },
                              activeColor: AppColors.primary,
                              contentPadding: EdgeInsets.zero,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: 16.0.p,
            child: _quizSubmitted
                ? Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  child: Padding(
                    padding: 16.0.p,
                    child: Column(
                      children: [
                        Text(
                          l10n.results(
                              _correctAnswers, _questions.length),
                          style: TextStyle(
                              fontSize: 22.f,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          l10n.correctAnswers(_correctAnswers),
                          style: TextStyle(
                              fontSize: 18.f, color: Colors.green),
                        ),
                        Text(
                          l10n.wrongAnswers(_wrongAnswers),
                          style: TextStyle(
                              fontSize: 18.f, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () async {
                    await _saveQuizResults();
                    if (mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(l10n.saveResult),
                ),
              ],
            )
                : ElevatedButton(
              onPressed: _submitQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(l10n.submitQuiz),
            ),
          ),
        ],
      ),
    );
  }
}