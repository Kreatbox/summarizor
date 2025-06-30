// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get editName => 'Edit Name';

  @override
  String get share => 'Share';

  @override
  String get ok => 'OK';

  @override
  String get editNameTitle => 'Edit Name';

  @override
  String get editNameContent => 'Please enter your new name.';

  @override
  String get fullName => 'Full Name';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get success => 'Success';

  @override
  String get nameUpdatedSuccess => 'Your name has been updated successfully.';

  @override
  String get error => 'Error';

  @override
  String get nameUpdatedError => 'Failed to update name. Please try again.';

  @override
  String get copied => 'Copied!';

  @override
  String get invitationCopied =>
      'The invitation message has been copied to your clipboard.';

  @override
  String get invitationMessage =>
      'We invite you to join the \"Summarizor app\" to learn more easily.';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get availableQuizzes => 'Available Quizzes';

  @override
  String get noQuizzesAvailable =>
      'No quizzes available. Go to \"Create Quiz\" to make one!';

  @override
  String get confirmDeletion => 'Confirm Deletion';

  @override
  String get areYouSureDeleteQuiz =>
      'Are you sure you want to permanently delete this quiz?';

  @override
  String get delete => 'Delete';

  @override
  String get deleted => 'Deleted';

  @override
  String get quizDeletedSuccess => 'The quiz has been deleted successfully.';

  @override
  String quizWithQuestions(int count) {
    return 'Quiz with $count questions';
  }

  @override
  String get result => 'Result: ';

  @override
  String get correct => ' correct';

  @override
  String get wrong => ' wrong';

  @override
  String get notYetTaken => 'Not yet taken. Tap to start.';

  @override
  String get retakeQuiz => 'Retake Quiz';

  @override
  String get deleteThisQuiz => 'Delete this quiz';

  @override
  String get takeQuiz => 'Take Quiz';

  @override
  String get incompleteQuiz => 'Incomplete Quiz';

  @override
  String get pleaseAnswerAllQuestions =>
      'Please answer all questions before submitting.';

  @override
  String question(Object index) {
    return 'Question $index';
  }

  @override
  String results(Object correctCount, Object totalCount) {
    return 'Results: $correctCount / $totalCount';
  }

  @override
  String correctAnswers(Object count) {
    return 'Correct: $count';
  }

  @override
  String wrongAnswers(Object count) {
    return 'Wrong: $count';
  }

  @override
  String get saveResult => 'Save Result';

  @override
  String get submitQuiz => 'Submit Quiz';

  @override
  String get summarizeTextOrFile => 'Summarize Text or File';

  @override
  String get createAQuiz => 'Create a Quiz';

  @override
  String get savedTextAndDocumentSummaries => 'Saved Text & Document Summaries';

  @override
  String get savedSummaryQuizzes => 'Saved Summary Quizzes';

  @override
  String get doTheQuizzes => 'Do the Quizzes';

  @override
  String get logout => 'Logout';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get hello => 'Hello,';

  @override
  String get guestUser => 'Guest User';

  @override
  String get loginSuccess => 'Login successful! Redirecting...';

  @override
  String get loginFailed => 'Login Failed';

  @override
  String get anUnknownErrorOccurred => 'An unknown error occurred.';

  @override
  String get invalidCredentials =>
      'No user found for that email or password is incorrect.';

  @override
  String get wrongPassword => 'Wrong password provided for that user.';

  @override
  String get invalidEmail => 'The email provided is invalid.';

  @override
  String get unexpectedError =>
      'An unexpected error occurred. Please try again.';

  @override
  String get logIn => 'Log In';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get pleaseEnterEmail => 'Please enter your Email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid Email';

  @override
  String get password => 'Password';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get finish => 'Finish';

  @override
  String get next => 'Next';

  @override
  String get createQuizTitle => 'Create a Quiz';

  @override
  String get quizGenerationPrompt =>
      'Paste text below or upload a PDF/TXT/DOCX file to generate a quiz.';

  @override
  String get pasteTextHere => 'Paste text here...';

  @override
  String get or => 'OR';

  @override
  String get clickToUploadFile => 'Click to Upload File';

  @override
  String uploaded(String fileName) {
    return 'Uploaded: $fileName';
  }

  @override
  String get generateQuiz => 'Generate Quiz';

  @override
  String get unsupportedPlatform => 'Unsupported Platform';

  @override
  String get fileProcessingWebError =>
      'File processing is not supported on web.';

  @override
  String get unsupportedFile => 'Unsupported File';

  @override
  String get docNotSupported =>
      'DOC files are not supported. Please convert it to DOCX format.';

  @override
  String unsupportedFileType(String extension) {
    return 'Please upload a PDF, TXT, or DOCX file.';
  }

  @override
  String get inputRequired => 'Input Required';

  @override
  String get pasteOrUploadFirst => 'Please paste text or upload a file first.';

  @override
  String get quizGeneratedSuccess => 'Quiz generated and saved successfully!';

  @override
  String get quizGenerationFailed =>
      'Failed to generate quiz. Your daily limit may have been exceeded.';

  @override
  String get networkError => 'Network Error';

  @override
  String get checkInternet =>
      'Please check your internet connection and try again.';

  @override
  String get limitReached => 'Limit Reached';

  @override
  String get geminiQuotaExceeded =>
      '⚠️ You have exceeded the daily free quota for the Gemini API.';

  @override
  String quizGenerationError(String error) {
    return 'An unexpected error occurred while generating the quiz.\n$error';
  }

  @override
  String get generatedQuiz => 'Generated Quiz:';

  @override
  String get clearAndGenerateNew => 'Clear and Generate New';

  @override
  String get unknownQuestionType => 'Unknown question type.';

  @override
  String get savedQuizzes => 'Saved Quizzes';

  @override
  String get noQuizzesGenerated => 'No quizzes generated yet for this account.';

  @override
  String quizSummaryTitle(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return 'Quiz Summary ($countString Questions)';
  }

  @override
  String get copyQuizSummary => 'Copy Quiz Summary';

  @override
  String get pleaseEnterFullName => 'Please enter your Fullname';

  @override
  String get passwordMinNumber => 'Password must contain at least one number';

  @override
  String get alreadyHaveAnAccount => 'Already have an account?';

  @override
  String get summarizeTitle => 'Summarize Text or File';

  @override
  String get summarizePrompt =>
      'Paste text below or upload a PDF/TXT/DOCX file to get a summary.';

  @override
  String get summarizeHint =>
      'You can type or paste any text you want to summarize...';

  @override
  String get generateSummary => 'Generate Summary';

  @override
  String get summaryGeneratedSuccess =>
      'Summary generated and saved successfully!';

  @override
  String get summaryGenerationError =>
      'An unexpected error occurred while summarizing.';

  @override
  String get generatedSummary => 'Generated Summary:';

  @override
  String get copySummary => 'Copy Summary';

  @override
  String get areYouSureDeleteSummary =>
      'Are you sure you want to permanently delete this summary?';

  @override
  String get savedSummaries => 'Saved Summaries';

  @override
  String get noSummariesSaved =>
      'There are no summaries saved for this account yet.';

  @override
  String get confirmDeleteSummaryMessage =>
      'Are you sure you want to permanently delete this summary?';

  @override
  String get summaryDeletedSuccess =>
      'The summary has been deleted successfully.';

  @override
  String summaryNumber(int number) {
    return 'Summary #$number';
  }

  @override
  String get summaryCopiedSuccess =>
      'The summary has been copied to your clipboard.';

  @override
  String get deleteThisSummary => 'Delete this summary';

  @override
  String questionLabel(int number) {
    return 'Q$number';
  }

  @override
  String get correctAnswerLabel => 'Correct Answer';

  @override
  String get quizCopiedSuccess => 'The quiz has been copied to your clipboard.';

  @override
  String get confirmDeletionMessage =>
      'Are you sure you want to permanently delete this quiz?';

  @override
  String get pasteOrUploadInstruction =>
      'Paste text below or upload a PDF/TXT/DOCX file to get a summary.';

  @override
  String get pasteTextHint =>
      'You can type or paste any text you want to summarize...';

  @override
  String get clickToUpload => 'Click to upload a file';

  @override
  String uploadedFileName(String fileName) {
    return 'Uploaded: $fileName';
  }

  @override
  String get generatedSummaryTitle => 'Generated Summary:';

  @override
  String get pasteTextOrUploadFile =>
      'Please paste text or upload a file first.';

  @override
  String get geminiApiLimit =>
      '⚠️ You may have exceeded your free daily limit for Gemini API usage.';

  @override
  String get checkInternetConnection =>
      'Please check your internet connection and try again.';

  @override
  String get noReadableTextInDocx => 'No readable text found in DOCX file.';

  @override
  String get newQuiz => 'New Quiz';

  @override
  String get onboarding1Title1 => 'Welcome to';

  @override
  String get onboarding1Title2 => 'Summarizer';

  @override
  String get onboarding1Desc =>
      'Welcome to Summarizer app! Whether you\'re a student, teacher, our app makes creating educational content simple and fast.';

  @override
  String get onboarding2Title1 => 'Learn smarter';

  @override
  String get onboarding2Title2 => 'Not harder!';

  @override
  String get onboarding2Desc =>
      'With our summarization and question generation app, you can turn your text files or study materials into concise summaries and tailored questions effortlessly.';

  @override
  String get onboarding3Title1 => 'Experience';

  @override
  String get onboarding3Title2 => 'AI powered!';

  @override
  String get onboarding3Desc =>
      'Start now by uploading your educational materials. We\'ll help you summarize them in minutes and create professional-level questions for effective review or testing.';

  @override
  String correctCount(int count) {
    return '$count correct';
  }

  @override
  String wrongCount(int count) {
    return '$count wrong';
  }

  @override
  String get geminiPromptTemplateEnglish =>
      'Provide a detailed and comprehensive summary of the following text:';

  @override
  String get geminiPromptTemplateArabic =>
      'قدّم ملخصًا تفصيليًا وشاملًا للنص التالي:';

  @override
  String get geminiQuizInstructionEnglish => 'Write the quiz in English only.';

  @override
  String geminiQuizPrompt(Object languageInstruction, Object numOfQuestions,
      Object jsonStructure, Object content) {
    return '$languageInstruction\n\nBased on the following text, generate a quiz with $numOfQuestions questions, including a mix of multiple-choice and true/false types.\nThe output MUST be a valid JSON object. Do not include any text, markdown, or explanation before or after the JSON object.\nUse the following exact JSON structure:\n$jsonStructure\nText:\n$content';
  }
}
