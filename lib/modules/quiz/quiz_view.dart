import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:summarizor/core/services/gemini_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../do_quizzes/do_quizzes_view.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  PlatformFile? file;
  bool isLoading = false;
  String? responseText;
  final TextEditingController textController = TextEditingController();
  final String _quizzesKey = 'generated_quizzes_list';

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'txt'],
      type: FileType.custom,
    );

    if (result != null) {
      setState(() {
        file = result.files.single;
        responseText = null;
        textController.clear();
      });
    }
  }

  Future<String> extractTextFromFile(String path) async {
    final extension = file!.extension;
    if (extension == 'pdf') {
      return "PDF reading not implemented in this snippet.";
    } else {
      return await File(path).readAsString();
    }
  }

  Future<void> _saveQuizAndNavigate(String quizText) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> currentQuizzes = [];
    final String? quizzesJson = prefs.getString(_quizzesKey);

    if (quizzesJson != null) {
      final List<dynamic> decodedList = json.decode(quizzesJson);
      currentQuizzes = decodedList.map((item) => Map<String, String>.from(item)).toList();
    }

    bool isDuplicate = currentQuizzes.any((quiz) => quiz['content'] == quizText);
    if (!isDuplicate) {
      currentQuizzes.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'content': quizText,
      });
      await prefs.setString(_quizzesKey, json.encode(currentQuizzes));
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DoQuizzesView(),
      ),
    );
  }

  Future<void> generateQuiz() async {
    setState(() {
      isLoading = true;
      responseText = null;
    });

    try {
      String content = "";

      if (file != null) {
        final filePath = file!.path!;
        content = await extractTextFromFile(filePath);
      } else if (textController.text.trim().isNotEmpty) {
        content = textController.text.trim();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please paste text or upload a file.")),
        );
        return;
      }

      final prompt = '''
Based on the following text, generate a quiz with 5 multiple-choice questions. For each question, provide 4 options (A, B, C, D) and indicate the correct answer. Format the output clearly.

Text:
$content
''';

      final geminiService = GeminiService();
      final response = await geminiService.generateContent(prompt);

      if (response != null) {
        setState(() => responseText = response);
        await _saveQuizAndNavigate(response);
      } else {
        setState(() {
          responseText =
          '⚠️ You have exceeded your free daily limit for Gemini API usage.';
        });
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred while generating quiz.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveQuizToFile(String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/quiz.txt';
    final file = File(filePath);
    await file.writeAsString(content);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Saved to: quiz.txt')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Quiz"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paste text or upload a PDF/TXT file to generate a quiz.',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: "Paste text here...",
                filled: true,
                fillColor: AppColors.aqua10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DottedBorder(
              dashPattern: const [6, 3],
              color: Colors.grey,
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              strokeWidth: 2,
              child: GestureDetector(
                onTap: pickFile,
                child: Container(
                  height: 130,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: file == null
                      ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file, size: 40, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("Click to upload"),
                    ],
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, size: 40, color: Colors.green),
                      const SizedBox(height: 10),
                      Text("Uploaded: ${file!.name}"),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: generateQuiz,
              icon: const Icon(Icons.quiz),
              label: const Text("Generate Quiz"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (responseText != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: AppColors.aqua10,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(responseText!),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: responseText!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied to clipboard')),
                            );
                          },
                          icon: const Icon(Icons.copy),
                          label: const Text("Copy"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
          ],
        ),
      ),
    );
  }
}