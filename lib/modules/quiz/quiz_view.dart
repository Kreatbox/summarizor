import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:summarizor/core/services/gemini_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:summarizor/core/services/responsive.dart';
import 'package:xml/xml.dart';
import '../../l10n/app_localizations.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  PlatformFile? file;
  bool isLoading = false;
  final TextEditingController textController = TextEditingController();
  String? _userId;
  Map<String, dynamic>? _generatedQuiz;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    final user = await CacheManager().getUser();
    if (user != null && mounted) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  void _showCustomDialog({
    required String title,
    required String content,
    required IconData iconData,
    required Color iconColor,
  }) {
    if (!mounted) return;
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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'txt', 'docx', 'doc'],
      type: FileType.custom,
    );

    if (result != null) {
      setState(() {
        file = result.files.single;
        textController.clear();
        _generatedQuiz = null;
      });
    }
  }

  Future<String> extractTextFromDocx(String path) async {
    if (!mounted) return "";
    final l10n = AppLocalizations.of(context)!;
    final bytes = await File(path).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      if (file.name == 'word/document.xml') {
        final content = utf8.decode(file.content as List<int>);
        final document = XmlDocument.parse(content);
        return document
            .findAllElements('w:t')
            .map((node) => node.text)
            .join(' ');
      }
    }
    return l10n.noReadableTextInDocx;
  }

  Future<void> generateQuiz() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      isLoading = true;
      _generatedQuiz = null;
    });

    try {
      String content = "";

      if (file != null) {
        if (kIsWeb || file!.path == null) {
          _showCustomDialog(
            title: l10n.unsupportedPlatform,
            content: l10n.fileProcessingWebError,
            iconData: Icons.error_outline_rounded,
            iconColor: Colors.red,
          );
          setState(() => isLoading = false);
          return;
        }

        final ext = file!.extension?.toLowerCase();
        final path = file!.path!;

        if (ext == 'pdf') {
          final fileBytes = await File(path).readAsBytes();
          final PdfDocument document = PdfDocument(inputBytes: fileBytes);
          content = PdfTextExtractor(document).extractText();
          document.dispose();
        } else if (ext == 'txt') {
          content = await File(path).readAsString();
        } else if (ext == 'docx') {
          content = await extractTextFromDocx(path);
        } else if (ext == 'doc') {
          _showCustomDialog(
            title: l10n.unsupportedFile,
            content: l10n.docNotSupported,
            iconData: Icons.error_outline_rounded,
            iconColor: Colors.red,
          );
          setState(() => isLoading = false);
          return;
        } else {
          _showCustomDialog(
            title: l10n.unsupportedFile,
            content: l10n.unsupportedFileType("pdf, txt, docx"),
            iconData: Icons.error_outline_rounded,
            iconColor: Colors.red,
          );
          setState(() => isLoading = false);
          return;
        }
      } else if (textController.text.trim().isNotEmpty) {
        content = textController.text.trim();
      } else {
        _showCustomDialog(
          title: l10n.inputRequired,
          content: l10n.pasteOrUploadFirst,
          iconData: Icons.warning_amber_rounded,
          iconColor: Colors.orange,
        );
        setState(() => isLoading = false);
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final int numOfQuestions = prefs.getInt('quiz_questions_count') ?? 50;
      final bool isArabic = _isArabicLanguage(content);

      final String languageInstruction = isArabic
          ? "اكتب الاختبار باللغة العربية فقط، وتجنب استخدام كلمات أو عبارات بالإنجليزية."
          : "Write the quiz in English only.";

      final prompt = '''
$languageInstruction

Based on the following text, generate a quiz with $numOfQuestions questions, including a mix of multiple-choice and true/false types.
The output MUST be a valid JSON object. Do not include any text, markdown, or explanation before or after the JSON object.
Use the following exact JSON structure:
{
  "questions": [
    {
      "question": "The question text goes here.",
      "type": "multipleChoice",
      "options": ["A) Option 1", "B) Option 2", "C) Option 3", "D) Option 4"],
      "correctAnswer": "A"
    },
    {
      "question": "The true/false question text goes here.",
      "type": "trueFalse",
      "options": ["True", "False"],
      "correctAnswer": "True"
    }
  ]
}
Text:
$content
''';

      final geminiService = GeminiService();
      final response = await geminiService.generateContent(prompt);

      if (response != null && response.isNotEmpty) {
        final cleanedResponse =
        response.replaceAll("```json", "").replaceAll("```", "").trim();
        final quizData = json.decode(cleanedResponse) as Map<String, dynamic>;

        await _saveQuiz(quizData);

        if (mounted) {
          _showCustomDialog(
            title: l10n.success,
            content: l10n.quizGeneratedSuccess,
            iconData: Icons.check_circle_outline_rounded,
            iconColor: Colors.green,
          );
          setState(() => _generatedQuiz = quizData);
        }
      } else {
        if (mounted) {
          _showCustomDialog(
            title: l10n.error,
            content: l10n.quizGenerationFailed,
            iconData: Icons.error_outline_rounded,
            iconColor: Colors.red,
          );
        }
      }
    } catch (e) {
      if (!mounted) return;

      if (e is SocketException) {
        _showCustomDialog(
          title: l10n.networkError,
          content: l10n.checkInternet,
          iconData: Icons.wifi_off_rounded,
          iconColor: Colors.orange,
        );
      } else if (e.toString().contains('quota_exceeded')) {
        _showCustomDialog(
          title: l10n.limitReached,
          content: l10n.geminiQuotaExceeded,
          iconData: Icons.warning_amber_rounded,
          iconColor: Colors.orange,
        );
      } else {
        _showCustomDialog(
          title: l10n.error,
          content: l10n.quizGenerationError(e.toString()),
          iconData: Icons.error_outline_rounded,
          iconColor: Colors.red,
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _saveQuiz(Map<String, dynamic> quizData) async {
    if (_userId == null || !mounted) return;
    final l10n = AppLocalizations.of(context)!;

    final prefs = await SharedPreferences.getInstance();
    final String userQuizzesKey = 'generated_quizzes_list_$_userId';
    List<dynamic> currentQuizzes = [];
    final String? quizzesJson = prefs.getString(userQuizzesKey);

    if (quizzesJson != null) {
      currentQuizzes = json.decode(quizzesJson);
    }

    String quizTitle = l10n.newQuiz;
    if (quizData.containsKey('questions') &&
        (quizData['questions'] as List).isNotEmpty) {
      quizTitle = quizData['questions'][0]['question'];
      if (quizTitle.length > 50) {
        quizTitle = "${quizTitle.substring(0, 50)}...";
      }
    }

    currentQuizzes.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': quizTitle,
      'quizData': quizData,
      'isCompleted': false,
      'correctAnswers': 0,
      'wrongAnswers': 0,
    });
    await prefs.setString(userQuizzesKey, json.encode(currentQuizzes));
  }

  void _resetView() {
    setState(() {
      _generatedQuiz = null;
      file = null;
      textController.clear();
    });
  }

  bool _isArabicLanguage(String text) {
    final arabicRegExp = RegExp(r'[\u0600-\u06FF]');
    return arabicRegExp.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createQuizTitle,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.quizGenerationPrompt,
              style: TextStyle(fontSize: 16.f),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: textController,
              onTap: () => setState(() {
                file = null;
              }),
              maxLines: 7,
              decoration: InputDecoration(
                labelText: l10n.pasteTextHere,
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                l10n.or,
                style: TextStyle(fontSize: 16.f, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: isLoading ? null : pickFile,
              child: DottedBorder(
                dashPattern: const [6, 3],
                color: Colors.grey,
                borderType: BorderType.RRect,
                radius: Radius.circular(12.r),
                strokeWidth: 2,
                child: Container(
                  height: 130.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(13),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: file == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.upload_file,
                          size: 40, color: Colors.grey),
                      const SizedBox(height: 10.0),
                      Text(l10n.clickToUploadFile),
                    ],
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle,
                          size: 40, color: Colors.green),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          l10n.uploaded(file!.name),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: isLoading ? null : generateQuiz,
              icon: const Icon(Icons.quiz, color: Colors.white),
              label: Text(l10n.generateQuiz,
                  style: const TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (_generatedQuiz != null) _buildQuizDisplaySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizDisplaySection() {
    final l10n = AppLocalizations.of(context)!;
    final List questions = _generatedQuiz!['questions'] ?? [];

    final bool isArabic = questions.isNotEmpty &&
        _isArabicLanguage(questions[0]['question'] ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.generatedQuiz,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20)),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.blue),
              tooltip: l10n.clearAndGenerateNew,
              onPressed: _resetView,
            ),
          ],
        ),
        Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final q = questions[index];
              final questionText = q['question'] ?? '';
              final type = q['type'] ?? 'multipleChoice';
              final options = List<String>.from(q['options'] ?? []);
              final correctAnswer = q['correctAnswer'] ?? '';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}. $questionText",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.f),
                      ),
                      SizedBox(height: 8.h),
                      if (type == "multipleChoice")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: options.map((option) {
                            final bool isCorrect =
                            option.startsWith(correctAnswer);
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Row(
                                children: [
                                  Icon(
                                    isCorrect
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: isCorrect ? Colors.green : Colors.grey,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontWeight: isCorrect
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isCorrect
                                            ? Colors.green
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      else if (type == "trueFalse")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: options.map((option) {
                            final bool isCorrect = option.toLowerCase() ==
                                correctAnswer.toLowerCase();
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Row(
                                children: [
                                  Icon(
                                    isCorrect
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: isCorrect ? Colors.green : Colors.grey,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    option,
                                    style: TextStyle(
                                      fontWeight: isCorrect
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isCorrect
                                          ? Colors.green
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      else
                        Text(l10n.unknownQuestionType),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}