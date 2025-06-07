import 'package:flutter/material.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizQuestion.fromString(String rawQuestionText) {
    final lines = rawQuestionText.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (lines.isEmpty) {
      throw FormatException("Raw question text is empty or malformed.");
    }

    String question = '';
    List<String> currentOptions = [];
    String? currentCorrectAnswer;

    int questionStartIndex = 0;
    if (lines[0].startsWith('**Question')) {
      questionStartIndex = 1;
    }
    if (lines.length > questionStartIndex) {
      question = lines[questionStartIndex];
    } else {
      throw FormatException("Could not find question text.");
    }

    for (int i = questionStartIndex + 1; i < lines.length; i++) {
      String line = lines[i];
      if (line.startsWith('A)') || line.startsWith('B)') || line.startsWith('C)') || line.startsWith('D)')) {
        currentOptions.add(line);
      } else if (line.contains('Correct Answer:')) {
        currentCorrectAnswer = line.split('Correct Answer:').last.replaceAll('**', '').trim();
      }
    }

    if (currentOptions.isEmpty || currentCorrectAnswer == null) {
      throw FormatException("Could not parse options or correct answer from: $rawQuestionText");
    }

    return QuizQuestion(
      question: question,
      options: currentOptions,
      correctAnswer: currentCorrectAnswer,
    );
  }
}