import 'package:flutter/material.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/models/quiz_model.dart';

class TakeQuizScreen extends StatefulWidget {
  final String quizContent;

  const TakeQuizScreen({super.key, required this.quizContent});

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  List<QuizQuestion> _questions = [];
  Map<int, String?> _selectedAnswers = {};
  bool _quizSubmitted = false;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;

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

  void _submitQuiz() {
    int correct = 0;
    int wrong = 0;

    for (int i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final selectedAnswer = _selectedAnswers[i];

      final String? selectedAnswerLetter = selectedAnswer?.split(')').first.trim(); // Get 'A', 'B', etc.

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
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _questions.length + (_quizSubmitted ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _questions.length) {
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
                      final optionLetter = option.split(')').first.trim(); // Get 'A', 'B', etc.
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
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: _quizSubmitted
                  ? Card(
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
                      const SizedBox(height: 20),
                      ElevatedButton(
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
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Retake Quiz'),
                      ),
                    ],
                  ),
                ),
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
            );
          }
        },
      ),
    );
  }
}