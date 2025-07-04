import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
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
import '../../l10n/app_localizations.dart';

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
  String language = 'en';

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  String detectLanguage(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text) ? 'ar' : 'en';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
      allowedExtensions: ['pdf', 'txt', 'docx'],
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
    final l10n = AppLocalizations.of(context)!;
    final extension = file!.extension?.toLowerCase();

    if (extension == 'pdf') {
      final bytes = await File(path).readAsBytes();
      final document = PdfDocument(inputBytes: bytes);
      final text = PdfTextExtractor(document).extractText();
      document.dispose();
      return text;
    } else if (extension == 'txt') {
      return await File(path).readAsString();
    } else if (extension == 'docx') {
      final bytes = File(path).readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);
      final documentFile = archive.files.firstWhere(
            (file) => file.name == 'word/document.xml',
        orElse: () => throw Exception('Invalid docx file structure'),
      );

      final content = utf8.decode(documentFile.content as List<int>);
      final docText = content
          .replaceAll(RegExp(r'<w:.*?>|</w:.*?>'), '')
          .replaceAll(RegExp(r'<[^>]+>'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      return docText;
    } else {
      throw UnsupportedError(l10n.unsupportedFileType(extension ?? ''));
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
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    if (_textController.text.isEmpty && file == null) {
      _showCustomDialog(
        title: l10n.inputRequired,
        content: l10n.pasteOrUploadFirst,
        iconData: Icons.warning_amber_rounded,
        iconColor: Colors.orange,
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

      final detectedLang = detectLanguage(contentToSummarize);
      language = detectedLang;

      String prompt;
      if (language == 'ar') {
        prompt =
        "${l10n.geminiPromptTemplateArabic}\n\n$contentToSummarize";
      } else {
        prompt =
        "${l10n.geminiPromptTemplateEnglish}\n\n$contentToSummarize";
      }

      final geminiService = GeminiService();
      final response = await geminiService.generateContent(prompt);

      if (response != null && response.isNotEmpty) {
        setState(() {
          responseText = response;
        });
        await _saveSummary(response);
        _showCustomDialog(
          title: l10n.success,
          content: l10n.summaryGeneratedSuccess,
          iconData: Icons.check_circle_outline_rounded,
          iconColor: Colors.green,
        );
      } else {
        _showCustomDialog(
          title: l10n.limitReached,
          content: l10n.geminiApiLimit,
          iconData: Icons.warning_amber_rounded,
          iconColor: Colors.orange,
        );
      }
    } catch (e) {
      if (e.toString().contains('quota_exceeded')) {
        _showCustomDialog(
          title: l10n.limitReached,
          content: l10n.geminiApiLimit,
          iconData: Icons.lock_outline_rounded,
          iconColor: Colors.red,
        );
      } else if (e is SocketException) {
        _showCustomDialog(
          title: l10n.networkError,
          content: l10n.checkInternetConnection,
          iconData: Icons.wifi_off_rounded,
          iconColor: Colors.orange,
        );
      } else {
        _showCustomDialog(
          title: l10n.error,
          content: l10n.summaryGenerationError,
          iconData: Icons.error_outline_rounded,
          iconColor: Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.summarizeTitle,
            style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: 16.p,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.summarizePrompt,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.f,
              ),
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
                labelText: l10n.pasteTextHere,
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                ),
                hintText: l10n.summarizeHint,
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
                l10n.or,
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
                    color: Colors.grey.withAlpha(13),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: file == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.upload_file,
                            size: 50, color: Colors.grey),
                        SizedBox(height: 10.h),
                        Text(l10n.clickToUpload),
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
                            l10n.uploadedFileName(file!.name),
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
              label: Text(
                l10n.generateSummary,
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 30.h),
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
                      Directionality(
                        textDirection: language == 'ar'
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Text(
                          l10n.generatedSummary,
                          style: TextStyle(
                            fontSize: 18.f,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Directionality(
                        textDirection: language == 'ar'
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Text(
                          responseText!,
                          style: TextStyle(height: 1.5.h, fontSize: 16.f),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: responseText!));
                          _showCustomDialog(
                            title: l10n.copied,
                            content: l10n.summaryCopiedSuccess,
                            iconData: Icons.copy_all_rounded,
                            iconColor: AppColors.primary,
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: Text(l10n.copySummary),
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