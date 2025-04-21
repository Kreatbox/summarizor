import 'package:flutter/material.dart';
import 'package:summarizor/core/services/responsive.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:summarizor/core/services/gemini_service.dart';
import 'package:summarizor/core/constants/app_colors.dart';

class SummarizeView extends StatefulWidget {
  const SummarizeView({super.key});

  @override
  State<SummarizeView> createState() => _SummarizeViewState();
}

class _SummarizeViewState extends State<SummarizeView> {
   String? _pdfPath;
  String? _textPath;

  Future<void> _generateSummaryAndQuiz(String text) async {
    final geminiService = GeminiService();
    final prompt = """You are an expert educator tasked with turning complex text into easy-to-understand lessons with accompanying quizzes.

Your task is to take the provided text and:

1.  **Divide it into {NUMBER} concise lessons.** Each lesson should cover a distinct concept or idea from the text.
2.  **For each lesson, provide a summary** of the key takeaways, written in a clear and engaging way.
3.  **For each lesson, generate one multiple-choice question.**
4.  **Provide four answer choices** for each question.
5.  **Indicate the correct answer** and provide a clear, concise explanation of why it is correct.

Format your response like this, use markdown for headers and bold text:
**Lesson 1:**
- lesson content
**Question 1:**
- question content
**Choices:**
- a. choice a
- b. choice b
- c. choice c
- d. choice d
**Correct Answer:**
- Answer: choice
- Explanation: explanation
**Lesson 2:**
...

Here is the text to process:

$text""";
    final response = await geminiService.generateContent(prompt);
    if(response != null){
      print(response);
    }
  }
  
  _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfPath = result.files.single.path;
      });
      print(_pdfPath);
      final content = await _readFileContent(_pdfPath);
      if (content != null) {
        await _generateSummaryAndQuiz(content);
      }
    }
  }

  _pickText() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      setState(() {
        _textPath = result.files.single.path;
      });
    }
    final content = await _readFileContent(_textPath);
    if (content != null) {
      await _generateSummaryAndQuiz(content);
    }
  }
  
  Future<String?> _readFileContent(String? path) async {
    if (path == null) return null;
    try {
      final file = File(path);
      final content = await file.readAsString();
      return content;
    } catch (e) {
      print('Error reading file: $e');
      return null;
    }
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          Center(
            child: Text(
              "Summarize",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: _pickPdf,
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.picture_as_pdf),
                      Text('Pick PDF'),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: _pickText,
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.text_fields),
                      Text('Pick Text'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}