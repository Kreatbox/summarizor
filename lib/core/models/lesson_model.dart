class Lesson {
  String content;
  List<Quiz> quizzes;

  Lesson({
    required this.content,
    required this.quizzes,
  });
}

class Quiz {
  String question;
  List<String> choices;
  String answer;
  String explanation;

  Quiz({
    required this.question,
    required this.choices,
    required this.answer,
    required this.explanation,
  });
}