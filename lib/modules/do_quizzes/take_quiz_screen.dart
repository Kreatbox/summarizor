import 'package:flutter/material.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/models/quiz_model.dart';
import 'package:shared_preferences/shared_preferences.dart'; // استيراد SharedPreferences
import 'dart:convert'; // استيراد لـ json.encode

class TakeQuizScreen extends StatefulWidget {
  final String quizContent;
  final String quizId; // لتحديد الاختبار المحدد

  const TakeQuizScreen({super.key, required this.quizContent, required this.quizId});

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  List<QuizQuestion> _questions = [];
  Map<int, String?> _selectedAnswers = {};
  bool _quizSubmitted = false;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  final String _quizzesKey = 'generated_quizzes_list';

  @override
  void initState() {
    super.initState();
    _parseQuizContent();
  }

  void _parseQuizContent() {
    final List<String> rawQuestionBlocks = widget.quizContent.split(RegExp(r'\*\*Question \d+:\*\*')).where((s) => s.trim().isNotEmpty).toList();

    for (String rawBlock in rawQuestionBlocks) {
      try {
        _questions.add(QuizQuestion.fromString(rawBlock.trim()));
      } catch (e) {
        print('Error parsing question block: $e for content: \n$rawBlock');
      }
    }

    for (int i = 0; i < _questions.length; i++) {
      _selectedAnswers[i] = null;
    }
  }

  Future<void> _saveQuizResults() async {
    final prefs = await SharedPreferences.getInstance();
    final String? quizzesJson = prefs.getString(_quizzesKey);
    List<Map<String, dynamic>> currentQuizzes = [];

    if (quizzesJson != null) {
      final List<dynamic> decodedList = json.decode(quizzesJson);
      currentQuizzes = decodedList.map((item) => Map<String, dynamic>.from(item)).toList();
    }

    // البحث عن الاختبار المحدد وتحديث حالته
    int quizIndex = currentQuizzes.indexWhere((q) => q['id'] == widget.quizId);
    if (quizIndex != -1) {
      currentQuizzes[quizIndex]['isCompleted'] = true;
      currentQuizzes[quizIndex]['correctAnswers'] = _correctAnswers;
      currentQuizzes[quizIndex]['wrongAnswers'] = _wrongAnswers;
      await prefs.setString(_quizzesKey, json.encode(currentQuizzes));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz results saved successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Could not find quiz to save results.')),
      );
    }
  }

  void _submitQuiz() {
    int correct = 0;
    int wrong = 0;

    for (int i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final selectedAnswer = _selectedAnswers[i];

      final String? selectedAnswerLetter = selectedAnswer?.split(')').first.trim();

      if (selectedAnswerLetter == question.correctAnswer) {
        correct++;
      } else {
        wrong++;
      }
    }

    setState(() {
      _quizSubmitted = true;
      _correctAnswers = correct;
      _wrongAnswers = wrong;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Quiz submitted! Correct: $correct, Wrong: $wrong')),
    );
  }

  Color _getOptionColor(int questionIndex, String optionLetter) {
    if (!_quizSubmitted) return Colors.black;

    final question = _questions[questionIndex];
    final selectedAnswerLetter = _selectedAnswers[questionIndex]?.split(')').first.trim();

    if (optionLetter == question.correctAnswer) {
      return Colors.green;
    } else if (selectedAnswerLetter == optionLetter && selectedAnswerLetter != question.correctAnswer) {
      return Colors.red;
    }
    return Colors.black;
  }

  IconData? _getOptionIcon(int questionIndex, String optionLetter) {
    if (!_quizSubmitted) return null;

    final question = _questions[questionIndex];
    final selectedAnswerLetter = _selectedAnswers[questionIndex]?.split(')').first.trim();

    if (optionLetter == question.correctAnswer) {
      return Icons.check_circle;
    } else if (selectedAnswerLetter == optionLetter && selectedAnswerLetter != question.correctAnswer) {
      return Icons.cancel;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Take Quiz"),
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text(
            'Error: Could not load quiz questions. Check quiz format.',
            style: TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Take Quiz"),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${index + 1}: ${question.question}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 15),
                        ...question.options.map((option) {
                          final optionLetter = option.split(')').first.trim();
                          final isSelected = _selectedAnswers[index] == option;
                          final isCorrectOption = optionLetter == question.correctAnswer;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: InkWell(
                              onTap: _quizSubmitted
                                  ? null
                                  : () {
                                setState(() {
                                  _selectedAnswers[index] = option;
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.aqua10 : Colors.grey[100],
                                  border: Border.all(
                                    color: _quizSubmitted
                                        ? (isCorrectOption ? Colors.green : (isSelected ? Colors.red : Colors.transparent))
                                        : (isSelected ? AppColors.primary : Colors.grey[300]!),
                                    width: _quizSubmitted ? 2.0 : (isSelected ? 2.0 : 1.0),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: _getOptionColor(index, optionLetter),
                                          fontWeight: _quizSubmitted && isCorrectOption ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    if (_quizSubmitted)
                                      Icon(
                                        _getOptionIcon(index, optionLetter),
                                        color: _getOptionColor(index, optionLetter),
                                      ),
                                  ],
                                ),
                              ),
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
            padding: const EdgeInsets.all(16.0),
            child: _quizSubmitted
                ? Column( // استخدام Column لترتيب الأزرار بشكل عمودي
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: AppColors.aqua10,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          'Quiz Results:',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Colors.green[700], size: 30),
                            const SizedBox(width: 10),
                            Text(
                              'Correct Answers: $_correctAnswers',
                              style: const TextStyle(fontSize: 18, color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel, color: Colors.red[700], size: 30),
                            const SizedBox(width: 10),
                            Text(
                              'Wrong Answers: $_wrongAnswers',
                              style: const TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // توزيع الأزرار
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _quizSubmitted = false;
                            _selectedAnswers.updateAll((key, value) => null);
                            _correctAnswers = 0;
                            _wrongAnswers = 0;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Retake Quiz', textAlign: TextAlign.center),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await _saveQuizResults();
                          Navigator.pop(context); // العودة إلى قائمة الاختبارات بعد الحفظ
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary, // لون مختلف لزر الحفظ
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Save Results', textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              ],
            )
                : ElevatedButton(
              onPressed: _submitQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Submit Quiz'),
            ),
          ),
        ],
      ),
    );
  }
}