import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get editName;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @editNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get editNameTitle;

  /// No description provided for @editNameContent.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new name.'**
  String get editNameContent;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @nameUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your name has been updated successfully.'**
  String get nameUpdatedSuccess;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @nameUpdatedError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update name. Please try again.'**
  String get nameUpdatedError;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copied;

  /// No description provided for @invitationCopied.
  ///
  /// In en, this message translates to:
  /// **'The invitation message has been copied to your clipboard.'**
  String get invitationCopied;

  /// No description provided for @invitationMessage.
  ///
  /// In en, this message translates to:
  /// **'We invite you to join the \"Summarizor app\" to learn more easily.'**
  String get invitationMessage;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @availableQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Available Quizzes'**
  String get availableQuizzes;

  /// No description provided for @noQuizzesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No quizzes available. Go to \"Create Quiz\" to make one!'**
  String get noQuizzesAvailable;

  /// No description provided for @confirmDeletion.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeletion;

  /// No description provided for @areYouSureDeleteQuiz.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this quiz?'**
  String get areYouSureDeleteQuiz;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @quizDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'The quiz has been deleted successfully.'**
  String get quizDeletedSuccess;

  /// No description provided for @quizWithQuestions.
  ///
  /// In en, this message translates to:
  /// **'Quiz with {count} questions'**
  String quizWithQuestions(int count);

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result: '**
  String get result;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **' correct'**
  String get correct;

  /// No description provided for @wrong.
  ///
  /// In en, this message translates to:
  /// **' wrong'**
  String get wrong;

  /// No description provided for @notYetTaken.
  ///
  /// In en, this message translates to:
  /// **'Not yet taken. Tap to start.'**
  String get notYetTaken;

  /// No description provided for @retakeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Retake Quiz'**
  String get retakeQuiz;

  /// No description provided for @deleteThisQuiz.
  ///
  /// In en, this message translates to:
  /// **'Delete this quiz'**
  String get deleteThisQuiz;

  /// No description provided for @takeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take Quiz'**
  String get takeQuiz;

  /// No description provided for @incompleteQuiz.
  ///
  /// In en, this message translates to:
  /// **'Incomplete Quiz'**
  String get incompleteQuiz;

  /// No description provided for @pleaseAnswerAllQuestions.
  ///
  /// In en, this message translates to:
  /// **'Please answer all questions before submitting.'**
  String get pleaseAnswerAllQuestions;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question {index}'**
  String question(Object index);

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results: {correctCount} / {totalCount}'**
  String results(Object correctCount, Object totalCount);

  /// No description provided for @correctAnswers.
  ///
  /// In en, this message translates to:
  /// **'Correct: {count}'**
  String correctAnswers(Object count);

  /// No description provided for @wrongAnswers.
  ///
  /// In en, this message translates to:
  /// **'Wrong: {count}'**
  String wrongAnswers(Object count);

  /// No description provided for @saveResult.
  ///
  /// In en, this message translates to:
  /// **'Save Result'**
  String get saveResult;

  /// No description provided for @submitQuiz.
  ///
  /// In en, this message translates to:
  /// **'Submit Quiz'**
  String get submitQuiz;

  /// No description provided for @summarizeTextOrFile.
  ///
  /// In en, this message translates to:
  /// **'Summarize Text or File'**
  String get summarizeTextOrFile;

  /// No description provided for @createAQuiz.
  ///
  /// In en, this message translates to:
  /// **'Create a Quiz'**
  String get createAQuiz;

  /// No description provided for @savedTextAndDocumentSummaries.
  ///
  /// In en, this message translates to:
  /// **'Saved Text & Document Summaries'**
  String get savedTextAndDocumentSummaries;

  /// No description provided for @savedSummaryQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Saved Summary Quizzes'**
  String get savedSummaryQuizzes;

  /// No description provided for @doTheQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Do the Quizzes'**
  String get doTheQuizzes;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get hello;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailed;

  /// No description provided for @anUnknownErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get anUnknownErrorOccurred;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'No user found for that email or password is incorrect.'**
  String get invalidCredentials;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided for that user.'**
  String get wrongPassword;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email provided is invalid.'**
  String get invalidEmail;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get unexpectedError;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @createQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a Quiz'**
  String get createQuizTitle;

  /// No description provided for @quizGenerationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Paste text below or upload a PDF/TXT/DOCX file to generate a quiz.'**
  String get quizGenerationPrompt;

  /// No description provided for @pasteTextHere.
  ///
  /// In en, this message translates to:
  /// **'Paste text here...'**
  String get pasteTextHere;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @clickToUploadFile.
  ///
  /// In en, this message translates to:
  /// **'Click to Upload File'**
  String get clickToUploadFile;

  /// No description provided for @uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded: {fileName}'**
  String uploaded(String fileName);

  /// No description provided for @generateQuiz.
  ///
  /// In en, this message translates to:
  /// **'Generate Quiz'**
  String get generateQuiz;

  /// No description provided for @unsupportedPlatform.
  ///
  /// In en, this message translates to:
  /// **'Unsupported Platform'**
  String get unsupportedPlatform;

  /// No description provided for @fileProcessingWebError.
  ///
  /// In en, this message translates to:
  /// **'File processing is not supported on web.'**
  String get fileProcessingWebError;

  /// No description provided for @unsupportedFile.
  ///
  /// In en, this message translates to:
  /// **'Unsupported File'**
  String get unsupportedFile;

  /// No description provided for @docNotSupported.
  ///
  /// In en, this message translates to:
  /// **'DOC files are not supported. Please convert it to DOCX format.'**
  String get docNotSupported;

  /// No description provided for @unsupportedFileType.
  ///
  /// In en, this message translates to:
  /// **'Please upload a PDF, TXT, or DOCX file.'**
  String unsupportedFileType(String extension);

  /// No description provided for @inputRequired.
  ///
  /// In en, this message translates to:
  /// **'Input Required'**
  String get inputRequired;

  /// No description provided for @pasteOrUploadFirst.
  ///
  /// In en, this message translates to:
  /// **'Please paste text or upload a file first.'**
  String get pasteOrUploadFirst;

  /// No description provided for @quizGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Quiz generated and saved successfully!'**
  String get quizGeneratedSuccess;

  /// No description provided for @quizGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate quiz. Your daily limit may have been exceeded.'**
  String get quizGenerationFailed;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network Error'**
  String get networkError;

  /// No description provided for @checkInternet.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get checkInternet;

  /// No description provided for @limitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit Reached'**
  String get limitReached;

  /// No description provided for @geminiQuotaExceeded.
  ///
  /// In en, this message translates to:
  /// **'⚠️ You have exceeded the daily free quota for the Gemini API.'**
  String get geminiQuotaExceeded;

  /// No description provided for @quizGenerationError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred while generating the quiz.\n{error}'**
  String quizGenerationError(String error);

  /// No description provided for @generatedQuiz.
  ///
  /// In en, this message translates to:
  /// **'Generated Quiz:'**
  String get generatedQuiz;

  /// No description provided for @clearAndGenerateNew.
  ///
  /// In en, this message translates to:
  /// **'Clear and Generate New'**
  String get clearAndGenerateNew;

  /// No description provided for @unknownQuestionType.
  ///
  /// In en, this message translates to:
  /// **'Unknown question type.'**
  String get unknownQuestionType;

  /// No description provided for @savedQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Saved Quizzes'**
  String get savedQuizzes;

  /// No description provided for @noQuizzesGenerated.
  ///
  /// In en, this message translates to:
  /// **'No quizzes generated yet for this account.'**
  String get noQuizzesGenerated;

  /// No description provided for @quizSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz Summary ({count} Questions)'**
  String quizSummaryTitle(int count);

  /// No description provided for @copyQuizSummary.
  ///
  /// In en, this message translates to:
  /// **'Copy Quiz Summary'**
  String get copyQuizSummary;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Fullname'**
  String get pleaseEnterFullName;

  /// No description provided for @passwordMinNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get passwordMinNumber;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @summarizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Summarize Text or File'**
  String get summarizeTitle;

  /// No description provided for @summarizePrompt.
  ///
  /// In en, this message translates to:
  /// **'Paste text below or upload a PDF/TXT/DOCX file to get a summary.'**
  String get summarizePrompt;

  /// No description provided for @summarizeHint.
  ///
  /// In en, this message translates to:
  /// **'You can type or paste any text you want to summarize...'**
  String get summarizeHint;

  /// No description provided for @generateSummary.
  ///
  /// In en, this message translates to:
  /// **'Generate Summary'**
  String get generateSummary;

  /// No description provided for @summaryGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Summary generated and saved successfully!'**
  String get summaryGeneratedSuccess;

  /// No description provided for @summaryGenerationError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred while summarizing.'**
  String get summaryGenerationError;

  /// No description provided for @generatedSummary.
  ///
  /// In en, this message translates to:
  /// **'Generated Summary:'**
  String get generatedSummary;

  /// No description provided for @copySummary.
  ///
  /// In en, this message translates to:
  /// **'Copy Summary'**
  String get copySummary;

  /// No description provided for @areYouSureDeleteSummary.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this summary?'**
  String get areYouSureDeleteSummary;

  /// No description provided for @savedSummaries.
  ///
  /// In en, this message translates to:
  /// **'Saved Summaries'**
  String get savedSummaries;

  /// No description provided for @noSummariesSaved.
  ///
  /// In en, this message translates to:
  /// **'There are no summaries saved for this account yet.'**
  String get noSummariesSaved;

  /// No description provided for @confirmDeleteSummaryMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this summary?'**
  String get confirmDeleteSummaryMessage;

  /// No description provided for @summaryDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'The summary has been deleted successfully.'**
  String get summaryDeletedSuccess;

  /// No description provided for @summaryNumber.
  ///
  /// In en, this message translates to:
  /// **'Summary #{number}'**
  String summaryNumber(int number);

  /// No description provided for @summaryCopiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'The summary has been copied to your clipboard.'**
  String get summaryCopiedSuccess;

  /// No description provided for @deleteThisSummary.
  ///
  /// In en, this message translates to:
  /// **'Delete this summary'**
  String get deleteThisSummary;

  /// No description provided for @questionLabel.
  ///
  /// In en, this message translates to:
  /// **'Q{number}'**
  String questionLabel(int number);

  /// No description provided for @correctAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer'**
  String get correctAnswerLabel;

  /// No description provided for @quizCopiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'The quiz has been copied to your clipboard.'**
  String get quizCopiedSuccess;

  /// No description provided for @confirmDeletionMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this quiz?'**
  String get confirmDeletionMessage;

  /// No description provided for @pasteOrUploadInstruction.
  ///
  /// In en, this message translates to:
  /// **'Paste text below or upload a PDF/TXT/DOCX file to get a summary.'**
  String get pasteOrUploadInstruction;

  /// No description provided for @pasteTextHint.
  ///
  /// In en, this message translates to:
  /// **'You can type or paste any text you want to summarize...'**
  String get pasteTextHint;

  /// No description provided for @clickToUpload.
  ///
  /// In en, this message translates to:
  /// **'Click to upload a file'**
  String get clickToUpload;

  /// No description provided for @uploadedFileName.
  ///
  /// In en, this message translates to:
  /// **'Uploaded: {fileName}'**
  String uploadedFileName(String fileName);

  /// No description provided for @generatedSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Generated Summary:'**
  String get generatedSummaryTitle;

  /// No description provided for @pasteTextOrUploadFile.
  ///
  /// In en, this message translates to:
  /// **'Please paste text or upload a file first.'**
  String get pasteTextOrUploadFile;

  /// No description provided for @geminiApiLimit.
  ///
  /// In en, this message translates to:
  /// **'⚠️ You may have exceeded your free daily limit for Gemini API usage.'**
  String get geminiApiLimit;

  /// No description provided for @checkInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get checkInternetConnection;

  /// No description provided for @noReadableTextInDocx.
  ///
  /// In en, this message translates to:
  /// **'No readable text found in DOCX file.'**
  String get noReadableTextInDocx;

  /// No description provided for @newQuiz.
  ///
  /// In en, this message translates to:
  /// **'New Quiz'**
  String get newQuiz;

  /// No description provided for @onboarding1Title1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get onboarding1Title1;

  /// No description provided for @onboarding1Title2.
  ///
  /// In en, this message translates to:
  /// **'Summarizer'**
  String get onboarding1Title2;

  /// No description provided for @onboarding1Desc.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Summarizer app! Whether you\'re a student, teacher, our app makes creating educational content simple and fast.'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title1.
  ///
  /// In en, this message translates to:
  /// **'Learn smarter'**
  String get onboarding2Title1;

  /// No description provided for @onboarding2Title2.
  ///
  /// In en, this message translates to:
  /// **'Not harder!'**
  String get onboarding2Title2;

  /// No description provided for @onboarding2Desc.
  ///
  /// In en, this message translates to:
  /// **'With our summarization and question generation app, you can turn your text files or study materials into concise summaries and tailored questions effortlessly.'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title1.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get onboarding3Title1;

  /// No description provided for @onboarding3Title2.
  ///
  /// In en, this message translates to:
  /// **'AI powered!'**
  String get onboarding3Title2;

  /// No description provided for @onboarding3Desc.
  ///
  /// In en, this message translates to:
  /// **'Start now by uploading your educational materials. We\'ll help you summarize them in minutes and create professional-level questions for effective review or testing.'**
  String get onboarding3Desc;

  /// No description provided for @correctCount.
  ///
  /// In en, this message translates to:
  /// **'{count} correct'**
  String correctCount(int count);

  /// No description provided for @wrongCount.
  ///
  /// In en, this message translates to:
  /// **'{count} wrong'**
  String wrongCount(int count);

  /// No description provided for @geminiPromptTemplateEnglish.
  ///
  /// In en, this message translates to:
  /// **'Provide a detailed and comprehensive summary of the following text:'**
  String get geminiPromptTemplateEnglish;

  /// No description provided for @geminiPromptTemplateArabic.
  ///
  /// In en, this message translates to:
  /// **'قدّم ملخصاً تفصيلياً وشاملاً للنص التالي:'**
  String get geminiPromptTemplateArabic;

  /// No description provided for @geminiQuizInstructionEnglish.
  ///
  /// In en, this message translates to:
  /// **'Write the quiz in English only.'**
  String get geminiQuizInstructionEnglish;

  /// No description provided for @geminiQuizPrompt.
  ///
  /// In en, this message translates to:
  /// **'{languageInstruction}\n\nBased on the following text, generate a quiz with {numOfQuestions} questions, including a mix of multiple-choice and true/false types.\nThe output MUST be a valid JSON object. Do not include any text, markdown, or explanation before or after the JSON object.\nUse the following exact JSON structure:\n{jsonStructure}\nText:\n{content}'**
  String geminiQuizPrompt(Object languageInstruction, Object numOfQuestions,
      Object jsonStructure, Object content);

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! You are now being redirected to the home page.'**
  String get welcomeBack;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
