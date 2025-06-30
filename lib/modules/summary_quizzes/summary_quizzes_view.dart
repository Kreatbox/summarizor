import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:summarizor/modules/do_quizzes/take_quiz_screen.dart';
import 'package:summarizor/core/services/responsive.dart';
import '../../l10n/app_localizations.dart';

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

      if (mounted) {
        setState(() {
          _quizzes = validQuizzes;
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

  void _showDeleteConfirmationDialog(String quizId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          icon: Icon(Icons.warning_amber_rounded,
              color: Colors.red[700], size: 48),
          title: Text(l10n.confirmDeletion, textAlign: TextAlign.center),
          content: Text(l10n.confirmDeletionMessage, textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child:
              Text(l10n.delete, style: const TextStyle(color: Colors.white)),
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
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _quizzes.removeWhere((quiz) => quiz['id'] == id);
    });
    _saveQuizzes();
    _showCustomDialog(
        title: l10n.deleted,
        content: l10n.quizDeletedSuccess,
        iconData: Icons.check_circle_outline_rounded,
        iconColor: Colors.green);
  }

  Future<void> _saveQuizzes() async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final String userQuizzesKey = 'generated_quizzes_list_$_userId';
    await prefs.setString(userQuizzesKey, json.encode(_quizzes));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.savedQuizzes, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _quizzes.isEmpty
          ? Center(
        child: Padding(
          padding: 24.0.p,
          child: Text(
            l10n.noQuizzesGenerated,
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

          return Card(
            margin: 8.0.pv,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
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
                l10n.quizSummaryTitle(questions.length),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    List.generate(questions.length, (qIndex) {
                      final question =
                      questions[qIndex] as Map<String, dynamic>;
                      final options = question['options'] as List<dynamic>;
                      final correctAnswer =
                      question['correctAnswer'] as String;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${l10n.questionLabel(qIndex + 1)}: ${question['question']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.f,
                                  color: Colors.black87),
                            ),
                            SizedBox(height: 8.h),
                            ...List.generate(options.length, (optIndex) {
                              final option = options[optIndex] as String;
                              final String optionKey =
                              (question['type'] == 'multipleChoice')
                                  ? option.split(')').first.trim()
                                  : option;
                              final bool isCorrect =
                              (optionKey == correctAnswer);

                              return Padding(
                                padding:
                                EdgeInsets.only(left: 8.0.w, top: 4.0.h),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 15.f,
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
                  padding: EdgeInsets.only(right: 8.0.w, bottom: 8.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon:
                        Icon(Icons.edit_note, color: Colors.blue[700]),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TakeQuizScreen(
                                quizData: quiz['quizData']
                                as Map<String, dynamic>,
                                quizId: quiz['id'] as String,
                                userId: _userId!,
                              ),
                            ),
                          ).then((_) {
                            _loadQuizzes();
                          });
                        },
                        tooltip: l10n.takeQuiz,
                      ),
                      IconButton(
                        icon: Icon(Icons.copy,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          final StringBuffer buffer = StringBuffer();
                          for (var i = 0; i < questions.length; i++) {
                            final q =
                            questions[i] as Map<String, dynamic>;
                            buffer.writeln(
                                '${l10n.questionLabel(i + 1)}: ${q['question']}');
                            final opts = q['options'] as List<dynamic>;
                            for (final option in opts) {
                              buffer.writeln('- $option');
                            }
                            buffer.writeln(
                                '${l10n.correctAnswerLabel}: ${q['correctAnswer']}');
                            buffer.writeln();
                          }
                          Clipboard.setData(
                              ClipboardData(text: buffer.toString()));
                          _showCustomDialog(
                              title: l10n.copied,
                              content: l10n.quizCopiedSuccess,
                              iconData: Icons.copy_all_rounded,
                              iconColor: AppColors.primary);
                        },
                        tooltip: l10n.copyQuizSummary,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_forever,
                            color: Colors.red[700]),
                        onPressed: () =>
                            _showDeleteConfirmationDialog(quiz['id'] as String),
                        tooltip: l10n.deleteThisQuiz,
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