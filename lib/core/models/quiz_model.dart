// lib/core/models/quiz_model.dart

enum QuestionType {
  multipleChoice,
  trueFalse,
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final QuestionType type;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.type,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    String typeString = json['type'] ?? 'multipleChoice';
    QuestionType questionType = QuestionType.values.firstWhere(
          (e) => e.toString() == 'QuestionType.$typeString',
      orElse: () => QuestionType.multipleChoice,
    );

    return QuizQuestion(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correctAnswer'] as String,
      type: questionType,
    );
  }
}