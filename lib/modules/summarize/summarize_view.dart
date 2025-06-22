import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summarizor/core/services/cache_manager.dart';
import 'package:summarizor/core/services/responsive.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:summarizor/core/services/gemini_service.dart';
import 'package:summarizor/core/constants/app_colors.dart';

class SummarizeView extends StatefulWidget {
  const SummarizeView({super.key});

  @override
  State<SummarizeView> createState() => _SummarizeViewState();
}

class _SummarizeViewState extends State<SummarizeView> {
  final TextEditingController _textController = TextEditingController();
  PlatformFile? file;
  bool isLoading = false;
  String? responseText;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentUserId() async {
    final user = await CacheManager().getUser();
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  void _showCustomDialog(
      {required String title,
        required String content,
        required IconData iconData,
        required Color iconColor}) {
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
              child: const Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'txt'],
      type: FileType.custom,
    );

    if (result != null) {
      setState(() {
        file = result.files.single;
        responseText = null;
        _textController.clear();
      });
    }
  }

  Future<String> extractTextFromFile(String path) async {
    final extension = file!.extension;
    if (extension == 'pdf') {
      final bytes = await File(path).readAsBytes();
      final document = PdfDocument(inputBytes: bytes);
      final text = PdfTextExtractor(document).extractText();
      document.dispose();
      return text;
    } else {
      return await File(path).readAsString();
    }
  }

  Future<void> _saveSummary(String newContent) async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final String userSummariesKey = 'generated_summaries_list_$_userId';
    final String? summariesJson = prefs.getString(userSummariesKey);
    List<Map<String, String>> summaries = [];

    if (summariesJson != null) {
      final List<dynamic> decodedList = json.decode(summariesJson);
      summaries =
          decodedList.map((item) => Map<String, String>.from(item)).toList();
    }

    summaries.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': newContent
    });

    final String updatedSummariesJson = json.encode(summaries);
    await prefs.setString(userSummariesKey, updatedSummariesJson);
  }

  Future<void> generateSummary() async {
    if (_textController.text.isEmpty && file == null) {
      _showCustomDialog(
          title: 'Input Required',
          content: 'Please paste text or upload a file first.',
          iconData: Icons.warning_amber_rounded,
          iconColor: Colors.orange);
      return;
    }

    setState(() => isLoading = true);
    String contentToSummarize = '';

    try {
      if (_textController.text.isNotEmpty) {
        contentToSummarize = _textController.text;
      } else if (file != null) {
        contentToSummarize = await extractTextFromFile(file!.path!);
      }

      final prefs = await SharedPreferences.getInstance();
      final String summaryLength =
          prefs.getString('summary_length') ?? 'Medium';
      String promptInstruction = "Provide a concise and clear summary";

      if (summaryLength == 'Short') {
        promptInstruction = "Provide a very short, one-paragraph summary";
      } else if (summaryLength == 'Long') {
        promptInstruction = "Provide a detailed and comprehensive summary";
      }

      final prompt =
          '$promptInstruction of the following text:\n\n$contentToSummarize';

      final geminiService = GeminiService();
      final response = await geminiService.generateContent(prompt);

      if (response != null && response.isNotEmpty) {
        setState(() {
          responseText = response;
        });
        await _saveSummary(response);
        _showCustomDialog(
            title: 'Success',
            content: 'Summary generated and saved successfully!',
            iconData: Icons.check_circle_outline_rounded,
            iconColor: Colors.green);
      } else {
        setState(() {
          responseText =
          '⚠️ You may have exceeded your free daily limit for Gemini API usage or an error occurred.';
        });
      }
    } catch (e) {
      _showCustomDialog(
          title: 'Error',
          content: 'An error occurred while reading or summarizing the file.',
          iconData: Icons.error_outline_rounded,
          iconColor: Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Summarize Text or File",
            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: 16.p,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Paste text below or upload a PDF/TXT file to get a summary.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.f,),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: _textController,
              maxLines: 8,
              onChanged: (text) {
                if (text.isNotEmpty) {
                  if (file != null) {
                    setState(() {
                      file = null;
                      responseText = null;
                    });
                  }
                }
              },
              decoration: InputDecoration(
                labelText: 'Paste text here',
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                ),
                hintText:
                'You can type or paste any text you want to summarize...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: Text(
                'OR',
                style: TextStyle(fontSize: 16.f, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10.h),
            DottedBorder(
              dashPattern: const [6, 3],
              color: Colors.grey,
              borderType: BorderType.RRect,
              radius: Radius.circular(12.r),
              strokeWidth: 2,
              child: GestureDetector(
                onTap: pickFile,
                child: Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: file == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file,
                            size: 50, color: Colors.grey),
                        SizedBox(height: 10.h),
                        const Text("Click to upload a file"),
                      ],
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle,
                            size: 50, color: Colors.green),
                        SizedBox(height: 10.h),
                        Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 8.0.h),
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
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: isLoading ? null : generateSummary,
              icon: const Icon(Icons.summarize, color: Colors.white),
              label: const Text(
                "Generate Summary",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (responseText != null)
              Card(
                color: AppColors.aqua10,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
                child: Padding(
                  padding: 16.p,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Generated Summary:",
                        style: TextStyle(
                            fontSize: 18.f,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      SizedBox(height: 10.h),
                      Text(responseText!,
                          style: TextStyle(height: 1.5.h, fontSize: 16.f)),
                      SizedBox(height: 20.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: responseText!));
                          _showCustomDialog(
                              title: 'Copied',
                              content:
                              'The summary has been copied to your clipboard.',
                              iconData: Icons.copy_all_rounded,
                              iconColor: AppColors.primary);
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text("Copy Summary"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 45),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}