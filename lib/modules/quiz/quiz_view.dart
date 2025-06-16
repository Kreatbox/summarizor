import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:summarizor/core/services/gemini_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../do_quizzes/do_quizzes_view.dart';

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

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    final user = await CacheManager().getUser();
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'txt'],
      type: FileType.custom,
    );

    if (result != null) {
      setState(() {
        file = result.files.single;
        textController.clear();
      });
    }
  }

  Future<void> _saveQuizAndNavigate(Map<String, dynamic> quizData) async {
    if (_userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final String userQuizzesKey = 'generated_quizzes_list_$_userId';
    List<dynamic> currentQuizzes = [];
    final String? quizzesJson = prefs.getString(userQuizzesKey);

    if (quizzesJson != null) {
      currentQuizzes = json.decode(quizzesJson);
    }

    currentQuizzes.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'quizData': quizData,
      'isCompleted': false,
      'correctAnswers': 0,
      'wrongAnswers': 0,
    });
    await prefs.setString(userQuizzesKey, json.encode(currentQuizzes));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DoQuizzesView(),
        ),
      );
    }
  }

  Future<void> generateQuiz() async {
    setState(() {
      isLoading = true;
    });

    try {
      String content = "";

      if (file != null) {
        if (kIsWeb || file!.path == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("File processing is not supported on web.")),
          );
          setState(() => isLoading = false);
          return;
        }

        if (file!.extension?.toLowerCase() == 'pdf') {
          final fileBytes = await File(file!.path!).readAsBytes();
          final PdfDocument document = PdfDocument(inputBytes: fileBytes);
          content = PdfTextExtractor(document).extractText();
          document.dispose();
        } else if (file!.extension?.toLowerCase() == 'txt') {
          content = await File(file!.path!).readAsString();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Unsupported file type.")),
          );
          setState(() => isLoading = false);
          return;
        }
      } else if (textController.text.trim().isNotEmpty) {
        content = textController.text.trim();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please paste text or upload a file.")),
        );
        setState(() => isLoading = false);
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final int numOfQuestions = prefs.getInt('quiz_questions_count') ?? 5;

      final prompt = '''
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
        await _saveQuizAndNavigate(quizData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
              Text("Failed to generate quiz. Daily limit may be exceeded.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Create a Quiz", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Paste text or upload a file to generate a quiz.',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: 'Paste text here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'OR',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: pickFile,
              child: DottedBorder(
                dashPattern: const [6, 3],
                color: Colors.grey,
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                strokeWidth: 2,
                child: Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: file == null
                      ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file,
                          size: 40, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("Click to Upload File"),
                    ],
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle,
                          size: 40, color: Colors.green),
                      const SizedBox(height: 10),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Uploaded: ${file!.name}",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
              onPressed: generateQuiz,
              icon: const Icon(Icons.quiz, color: Colors.white),
              label: const Text("Generate Quiz",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
