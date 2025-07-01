// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get editName => 'تعديل الاسم';

  @override
  String get share => 'مشاركة';

  @override
  String get ok => 'موافق';

  @override
  String get editNameTitle => 'تعديل الاسم';

  @override
  String get editNameContent => 'الرجاء إدخال اسمك الجديد.';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get success => 'نجاح';

  @override
  String get nameUpdatedSuccess => 'تم تحديث اسمك بنجاح.';

  @override
  String get error => 'خطأ';

  @override
  String get nameUpdatedError => 'فشل تحديث الاسم. الرجاء المحاولة مرة أخرى.';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get invitationCopied => 'تم نسخ رسالة الدعوة إلى الحافظة الخاصة بك.';

  @override
  String get invitationMessage =>
      'ندعوكم للانضمام إلى تطبيق \"Summarizor\" للتعلم بسهولة أكبر.';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get availableQuizzes => 'الاختبارات المتاحة';

  @override
  String get noQuizzesAvailable =>
      'لا توجد اختبارات متاحة. اذهب إلى \"إنشاء اختبار\" لعمل واحد!';

  @override
  String get confirmDeletion => 'تأكيد الحذف';

  @override
  String get areYouSureDeleteQuiz =>
      'هل أنت متأكد أنك تريد حذف هذا الاختبار بشكل دائم؟';

  @override
  String get delete => 'حذف';

  @override
  String get deleted => 'تم الحذف';

  @override
  String get quizDeletedSuccess => 'تم حذف الاختبار بنجاح.';

  @override
  String quizWithQuestions(int count) {
    return 'اختبار بـ $count سؤال';
  }

  @override
  String get result => 'النتيجة: ';

  @override
  String get correct => ' صحيحة';

  @override
  String get wrong => ' خاطئة';

  @override
  String get notYetTaken => 'لم يتم إجراؤه بعد. انقر للبدء.';

  @override
  String get retakeQuiz => 'إعادة الاختبار';

  @override
  String get deleteThisQuiz => 'حذف هذا الاختبار';

  @override
  String get takeQuiz => 'ابدأ الاختبار';

  @override
  String get incompleteQuiz => 'اختبار غير مكتمل';

  @override
  String get pleaseAnswerAllQuestions =>
      'الرجاء الإجابة على جميع الأسئلة قبل الإرسال.';

  @override
  String question(Object index) {
    return 'سؤال $index';
  }

  @override
  String results(Object correctCount, Object totalCount) {
    return 'النتائج: $correctCount / $totalCount';
  }

  @override
  String correctAnswers(Object count) {
    return 'صحيحة: $count';
  }

  @override
  String wrongAnswers(Object count) {
    return 'خاطئة: $count';
  }

  @override
  String get saveResult => 'حفظ النتيجة';

  @override
  String get submitQuiz => 'إرسال الاختبار';

  @override
  String get summarizeTextOrFile => 'لخص نصاً أو ملفاً';

  @override
  String get createAQuiz => 'أنشئ اختباراً';

  @override
  String get savedTextAndDocumentSummaries =>
      'ملخصات النصوص والمستندات المحفوظة';

  @override
  String get savedSummaryQuizzes => 'ملخصات الاختبارات المحفوظة';

  @override
  String get doTheQuizzes => 'قم بحل الاختبارات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get version => 'الإصدار 1.0.0';

  @override
  String get hello => 'مرحباً،';

  @override
  String get guestUser => 'مستخدم زائر';

  @override
  String get loginSuccess => 'تم تسجيل الدخول بنجاح! ';

  @override
  String get loginFailed => 'فشل تسجيل الدخول';

  @override
  String get anUnknownErrorOccurred => 'حدث خطأ غير معروف.';

  @override
  String get invalidCredentials =>
      'لا يوجد مستخدم لهذا البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get wrongPassword => 'كلمة المرور المقدمة لهذا المستخدم خاطئة.';

  @override
  String get invalidEmail => 'البريد الإلكتروني المقدم غير صالح.';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع. الرجاء المحاولة مرة أخرى.';

  @override
  String get logIn => 'تسجيل الدخول';

  @override
  String get dontHaveAnAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get pleaseEnterEmail => 'الرجاء إدخال بريدك الإلكتروني';

  @override
  String get pleaseEnterValidEmail => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get password => 'كلمة المرور';

  @override
  String get pleaseEnterPassword => 'الرجاء إدخال كلمة المرور الخاصة بك';

  @override
  String get finish => 'إنهاء';

  @override
  String get next => 'التالي';

  @override
  String get createQuizTitle => 'إنشاء اختبار';

  @override
  String get quizGenerationPrompt =>
      'الصق نصاً أو قم بتحميل ملف لإنشاء اختبار.';

  @override
  String get pasteTextHere => 'الصق النص هنا...';

  @override
  String get or => 'أو';

  @override
  String get clickToUploadFile => 'انقر لتحميل ملف';

  @override
  String uploaded(String fileName) {
    return 'تم التحميل: $fileName';
  }

  @override
  String get generateQuiz => 'إنشاء اختبار';

  @override
  String get unsupportedPlatform => 'منصة غير مدعومة';

  @override
  String get fileProcessingWebError => 'معالجة الملفات غير مدعومة على الويب.';

  @override
  String get unsupportedFile => 'ملف غير مدعوم';

  @override
  String get docNotSupported =>
      'ملفات DOC غير مدعومة. يرجى تحويلها إلى تنسيق DOCX.';

  @override
  String unsupportedFileType(String extension) {
    return 'يرجى تحميل ملف PDF أو TXT أو DOCX.';
  }

  @override
  String get inputRequired => 'الإدخال مطلوب';

  @override
  String get pasteOrUploadFirst => 'الرجاء لصق نص أو تحميل ملف أولاً.';

  @override
  String get quizGeneratedSuccess => 'تم إنشاء الاختبار وحفظه بنجاح!';

  @override
  String get quizGenerationFailed =>
      'فشل إنشاء الاختبار. ربما تجاوزت حدك اليومي.';

  @override
  String get networkError => 'خطأ في الشبكة';

  @override
  String get checkInternet =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get limitReached => 'تم الوصول إلى الحد الأقصى';

  @override
  String get geminiQuotaExceeded =>
      '⚠️ لقد تجاوزت الحصة اليومية المجانية لواجهة برمجة تطبيقات Gemini.';

  @override
  String quizGenerationError(String error) {
    return 'حدث خطأ غير متوقع أثناء إنشاء الاختبار.\n$error';
  }

  @override
  String get generatedQuiz => 'الاختبار المُنشأ:';

  @override
  String get clearAndGenerateNew => 'مسح وإنشاء جديد';

  @override
  String get unknownQuestionType => 'نوع سؤال غير معروف.';

  @override
  String get savedQuizzes => 'الاختبارات المحفوظة';

  @override
  String get noQuizzesGenerated => 'لم يتم إنشاء اختبارات لهذا الحساب بعد.';

  @override
  String quizSummaryTitle(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return 'ملخص الاختبار ($countString أسئلة)';
  }

  @override
  String get copyQuizSummary => 'نسخ ملخص الاختبار';

  @override
  String get pleaseEnterFullName => 'الرجاء إدخال اسمك الكامل';

  @override
  String get passwordMinNumber =>
      'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';

  @override
  String get alreadyHaveAnAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get summarizeTitle => 'تلخيص نص أو ملف';

  @override
  String get summarizePrompt =>
      'الصق نصاً أدناه أو قم بتحميل ملف PDF/TXT/DOCX للحصول على ملخص.';

  @override
  String get summarizeHint => 'يمكنك كتابة أو لصق أي نص تريد تلخيصه...';

  @override
  String get generateSummary => 'إنشاء ملخص';

  @override
  String get summaryGeneratedSuccess => 'تم إنشاء الملخص وحفظه بنجاح!';

  @override
  String get summaryGenerationError => 'حدث خطأ غير متوقع أثناء التلخيص.';

  @override
  String get generatedSummary => 'الملخص المُنشأ:';

  @override
  String get copySummary => 'نسخ الملخص';

  @override
  String get areYouSureDeleteSummary =>
      'هل أنت متأكد أنك تريد حذف هذا الملخص بشكل دائم؟';

  @override
  String get savedSummaries => 'الملخصات المحفوظة';

  @override
  String get noSummariesSaved => 'لا توجد ملخصات محفوظة لهذا الحساب بعد.';

  @override
  String get confirmDeleteSummaryMessage =>
      'هل أنت متأكد من رغبتك في حذف هذا الملخص بشكل دائم؟';

  @override
  String get summaryDeletedSuccess => 'تم حذف الملخص بنجاح.';

  @override
  String summaryNumber(int number) {
    return 'ملخص #$number';
  }

  @override
  String get summaryCopiedSuccess => 'تم نسخ الملخص إلى الحافظة الخاصة بك.';

  @override
  String get deleteThisSummary => 'حذف هذا الملخص';

  @override
  String questionLabel(int number) {
    return 'س$number';
  }

  @override
  String get correctAnswerLabel => 'الإجابة الصحيحة';

  @override
  String get quizCopiedSuccess => 'تم نسخ الاختبار إلى الحافظة.';

  @override
  String get confirmDeletionMessage =>
      'هل أنت متأكد من رغبتك في حذف هذا الاختبار بشكل دائم؟';

  @override
  String get pasteOrUploadInstruction =>
      'الصق النص أدناه أو قم بتحميل ملف PDF/TXT/DOCX للحصول على ملخص.';

  @override
  String get pasteTextHint => 'يمكنك كتابة أو لصق أي نص تريد تلخيصه...';

  @override
  String get clickToUpload => 'انقر لتحميل ملف';

  @override
  String uploadedFileName(String fileName) {
    return 'تم الرفع: $fileName';
  }

  @override
  String get generatedSummaryTitle => 'الملخص المُنشأ:';

  @override
  String get pasteTextOrUploadFile => 'يرجى لصق نص أو تحميل ملف أولاً.';

  @override
  String get geminiApiLimit =>
      '⚠️ ربما تكون قد تجاوزت حدك اليومي المجاني لاستخدام Gemini API.';

  @override
  String get checkInternetConnection =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get noReadableTextInDocx =>
      'لم يتم العثور على نص قابل للقراءة في ملف DOCX.';

  @override
  String get newQuiz => 'اختبار جديد';

  @override
  String get onboarding1Title1 => 'أهلاً بك في';

  @override
  String get onboarding1Title2 => 'Summarizer';

  @override
  String get onboarding1Desc =>
      'مرحبًا بك في تطبيق Summarizer! سواء كنت طالباً أو معلماً، فإن تطبيقنا يجعل إنشاء المحتوى التعليمي أمراً بسيطاً وسريعاً.';

  @override
  String get onboarding2Title1 => 'تعلم بذكاء';

  @override
  String get onboarding2Title2 => 'لا بجهد أكبر!';

  @override
  String get onboarding2Desc =>
      'باستخدام تطبيقنا للتلخيص وتوليد الأسئلة، يمكنك تحويل ملفاتك النصية أو موادك الدراسية إلى ملخصات موجزة وأسئلة مخصصة دون عناء.';

  @override
  String get onboarding3Title1 => 'جرّب قوة';

  @override
  String get onboarding3Title2 => 'الذكاء الاصطناعي!';

  @override
  String get onboarding3Desc =>
      'ابدأ الآن بتحميل موادك التعليمية. سنساعدك في تلخيصها في دقائق وإنشاء أسئلة بمستوى احترافي لمراجعة أو اختبار فعال.';

  @override
  String correctCount(int count) {
    return '$count صحيحة';
  }

  @override
  String wrongCount(int count) {
    return '$count خاطئة';
  }

  @override
  String get geminiPromptTemplateEnglish =>
      'Provide a detailed and comprehensive summary of the following text:';

  @override
  String get geminiPromptTemplateArabic =>
      'قدّم ملخصاً تفصيلياً وشاملاً للنص التالي:';

  @override
  String get geminiQuizInstructionEnglish => 'Write the quiz in English only.';

  @override
  String geminiQuizPrompt(Object languageInstruction, Object numOfQuestions,
      Object jsonStructure, Object content) {
    return '$languageInstruction\n\nبناءً على النص التالي، قم بإنشاء اختبار من $numOfQuestions سؤال، يتضمن مزيجاً من أنواع الاختيار من متعدد والصواب والخطأ.\nيجب أن يكون الناتج كائن JSON صالح. لا تقم بتضمين أي نص أو markdown أو شرح قبل أو بعد كائن JSON.\nاستخدم بنية JSON الدقيقة التالية:\n$jsonStructure\nالنص:\n$content';
  }

  @override
  String get welcomeBack => 'أهلاً بعودتك! يتم توجيهك الآن للصفحة الرئيسية.';
}
