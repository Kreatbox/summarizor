import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final String _summariesKey = 'generated_summaries_list';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
    final prefs = await SharedPreferences.getInstance();
    final String? summariesJson = prefs.getString(_summariesKey);
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
    await prefs.setString(_summariesKey, updatedSummariesJson);
  }

  Future<void> generateSummary() async {
    if (_textController.text.isEmpty && file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please paste text or upload a file first.")),
      );
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

      final prompt =
          'Provide a concise and clear summary of the following text:\n\n$contentToSummarize';

      final geminiService = GeminiService();
      final response = await geminiService.generateContent(prompt);

      if (response != null && response.isNotEmpty) {
        setState(() {
          responseText = response;
        });
        await _saveSummary(response);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Summary saved successfully!')),
        );
      } else {
        setState(() {
          responseText =
          '⚠️ You may have exceeded your free daily limit for Gemini API usage or an error occurred.';
        });
      }
    } catch (e) {
      print('❌ Error during summarization: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error reading or summarizing file.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Summarize Text or File"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Paste text below or upload a PDF/TXT file to get a summary.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 20),
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
                hintText:
                'You can type or paste any text you want to summarize...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'OR',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DottedBorder(
              dashPattern: const [6, 3],
              color: Colors.grey,
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              strokeWidth: 2,
              child: GestureDetector(
                onTap: pickFile,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  child: Center(
                    child: file == null
                        ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file,
                            size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Click to upload a file"),
                      ],
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle,
                            size: 50, color: Colors.green),
                        const SizedBox(height: 10),
                        Text("Uploaded: ${file!.name}"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isLoading ? null : generateSummary,
              icon: const Icon(Icons.summarize),
              label: const Text("Generate Summary"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (responseText != null)
              Card(
                color: AppColors.aqua10,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Generated Summary:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      const SizedBox(height: 10),
                      Text(responseText!,
                          style: TextStyle(height: 1.5.h, fontSize: 16)),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: responseText!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('✅ Copied to clipboard')),
                          );
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