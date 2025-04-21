import 'dart:convert' show utf8;
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:summarizor/core/services/responsive.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:summarizor/core/services/gemini_service.dart';
import 'package:summarizor/core/constants/app_colors.dart';
import 'package:path_provider/path_provider.dart';

class SummarizeView extends StatefulWidget {
  const SummarizeView({super.key});

  @override
  State<SummarizeView> createState() => _SummarizeViewState();
}

class _SummarizeViewState extends State<SummarizeView> {
  PlatformFile? file;
  bool isLoading = false;
  String? responseText;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'txt'],
      type: FileType.custom,
    );

    if (result != null) {
      setState(() {
        file = result.files.single;
        responseText = null;
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
      return text ?? "No text found in PDF.";
    } else {
      return await File(path).readAsString();
    }
  }

  Future<void> summarizeFile() async {
    if (file == null) return;

    setState(() => isLoading = true);

    try {
      final filePath = file!.path!;
      final content = await extractTextFromFile(filePath);

      final prompt = '''
You are an expert educator tasked with turning complex text into easy-to-understand lessons with accompanying quizzes.
Here is the text to process:

$content
''';

      final geminiService = GeminiService();
      final response = await geminiService.generateContent(prompt);

      if (response != null) {
        setState(() {
          responseText = response;
        });
      } else {
        setState(() {
          responseText =
          '⚠️ You have exceeded your free daily limit for Gemini API usage. Please wait until tomorrow or upgrade to a paid plan.';
        });
      }
    } catch (e) {
      print('❌ Error during summarization: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error reading or summarizing file.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveSummaryToFile(String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/summary.txt';
    final file = File(filePath);
    await file.writeAsString(content);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Saved to: summary.txt')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Summarize Book"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload a PDF or TXT file to generate a concise summary.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 10),
            DottedBorder(
              dashPattern: [6, 3],
              color: Colors.grey,
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              strokeWidth: 2,
              child: GestureDetector(
                onTap: pickFile,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  child: Center(
                    child: file == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file,
                            size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Click to upload"),
                      ],
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle,
                            size: 50, color: Colors.green),
                        SizedBox(height: 10),
                        Text("Uploaded: ${file!.name}"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: file == null ? null : summarizeFile,
              icon: Icon(Icons.summarize),
              label: Text("Summarize Book"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (responseText != null)
              ...[
                Card(
                  color: AppColors.aqua10,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(responseText!,style: TextStyle(height: 2.h),),
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
                            SnackBar(content: Text('✅ Copied to clipboard')),
                          );
                        },
                        icon: Icon(Icons.copy),
                        label: Text("Copy"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => saveSummaryToFile(responseText!),
                        icon: Icon(Icons.download),
                        label: Text("Download"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
          ],
        ),
      ),
    );
  }
}
