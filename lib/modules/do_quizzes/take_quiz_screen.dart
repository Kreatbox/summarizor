import 'package:flutter/material.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/models/quiz_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:summarizor/core/services/responsive.dart';


class TakeQuizScreen extends StatefulWidget {
  final Map<String, dynamic> quizData;
  final String quizId;

  const TakeQuizScreen({super.key, required this.quizData, required this.quizId});

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  List<QuizQuestion> _questions = [];
  Map<int, String> _selectedAnswers = {};
  bool _quizSubmitted = false;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  final String _quizzesKey = 'generated_quizzes_list';

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

  Future<void> _saveQuizResults() async {
    final prefs = await SharedPreferences.getInstance();
    final String? quizzesJson = prefs.getString(_quizzesKey);
    List<dynamic> currentQuizzes = [];

    if (quizzesJson != null) {
      currentQuizzes = json.decode(quizzesJson);
    }

    int quizIndex = currentQuizzes.indexWhere((q) => q['id'] == widget.quizId);
    if (quizIndex != -1) {
      currentQuizzes[quizIndex]['isCompleted'] = true;
      currentQuizzes[quizIndex]['correctAnswers'] = _correctAnswers;
      currentQuizzes[quizIndex]['wrongAnswers'] = _wrongAnswers;
      await prefs.setString(_quizzesKey, json.encode(currentQuizzes));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quiz results saved successfully!')),
        );
      }
    }
  }

  void _submitQuiz() {
    if (_selectedAnswers.length != _questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions before submitting.')),
      );
      return;
    }

    int correct = 0;
    for (int i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final selectedAnswer = _selectedAnswers[i];

      String selectedKey = selectedAnswer!;
      if(question.type == QuestionType.multipleChoice){
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
    if(question.type == QuestionType.multipleChoice){
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Take Quiz", style: TextStyle(color: Colors.white)),
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
                  margin:  10.0.pv,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  child: Padding(
                    padding: 16.0.pv,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${index + 1}: ${question.question}',
                          style:  TextStyle(fontSize: 18.f, fontWeight: FontWeight.bold),
                        ),
                         SizedBox(height: 15.h),
                        ...question.options.map((option) {
                          return Padding(
                            padding:  4.0.pv,
                            child: RadioListTile<String>(
                              title: Text(
                                option,
                                style: TextStyle(color: _getOptionColor(index, option)),
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
                  child: Padding(
                    padding: 16.0.p,
                    child: Column(children: [
                      Text(
                        'Results: $_correctAnswers / ${_questions.length}',
                        style: TextStyle(fontSize: 22.f, fontWeight: FontWeight.bold),
                      ),
                       SizedBox(height: 10.h),
                      Text(
                        'Correct: $_correctAnswers',
                        style:  TextStyle(fontSize: 18.f, color: Colors.green),
                      ),
                      Text(
                        'Wrong: $_wrongAnswers',
                        style:  TextStyle(fontSize: 18.f, color: Colors.red),
                      ),
                    ],),
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
                  ),
                  child: const Text('Finish and Save'),
                ),
              ],
            )
                : ElevatedButton(
              onPressed: _submitQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Submit Quiz'),
            ),
          ),
        ],
      ),
    );
  }
}