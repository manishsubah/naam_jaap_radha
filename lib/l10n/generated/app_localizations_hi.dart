// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'जापमाला';

  @override
  String get navHome => 'मुख्य';

  @override
  String get navJaap => 'जाप';

  @override
  String get navHistory => 'इतिहास';

  @override
  String get navThoughts => 'विचार';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonSave => 'सहेजें';

  @override
  String get commonAdd => 'जोड़ें';

  @override
  String get commonDelete => 'हटाएँ';

  @override
  String get commonRemove => 'हटाएँ';

  @override
  String get commonUndo => 'वापस लें';

  @override
  String get commonStop => 'रोकें';

  @override
  String get commonAll => 'सभी';

  @override
  String get commonTotal => 'कुल';

  @override
  String get commonToday => 'आज';

  @override
  String get removedNaam => 'हटाया गया नाम';

  @override
  String get jaapName => 'जाप का नाम';

  @override
  String get todaysCount => 'आज की गिनती';

  @override
  String jaapCount(String count) {
    return '$count जाप';
  }

  @override
  String get naamRadha => 'राधा';

  @override
  String get naamRam => 'राम';

  @override
  String get naamSitaRam => 'सीताराम';

  @override
  String get naamKrishna => 'कृष्ण';

  @override
  String get naamShiv => 'ॐ नमः शिवाय';

  @override
  String get naamHanuman => 'हनुमान';

  @override
  String get naamOm => 'ॐ';

  @override
  String get naamWaheguru => 'वाहेगुरु';

  @override
  String get greetingRadha => 'राधे राधे';

  @override
  String get greetingRam => 'जय श्री राम';

  @override
  String get greetingSitaRam => 'जय सिया राम';

  @override
  String get greetingKrishna => 'हरे कृष्ण';

  @override
  String get greetingShiv => 'हर हर महादेव';

  @override
  String get greetingHanuman => 'जय बजरंगबली';

  @override
  String get greetingOm => 'ॐ शांति';

  @override
  String get greetingWaheguru => 'वाहेगुरु जी';

  @override
  String homeGoalProgress(String goal) {
    return 'आज $goal में से';
  }

  @override
  String homeStartJaap(String naam) {
    return '$naam जाप शुरू करें';
  }

  @override
  String homeStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'दिन लगातार',
    );
    return '$_temp0';
  }

  @override
  String get homeMalasToday => 'आज की मालाएँ';

  @override
  String get homeLifetime => 'कुल जाप';

  @override
  String get homeVachanTitle => 'आज का वचन';

  @override
  String get homeCaptureThought => 'एक विचार लिखें';

  @override
  String get homeLatestThought => 'नवीनतम विचार';

  @override
  String get homeCaptureHint => 'जाप के बाद अपने मन की बात लिखें या बोलें।';

  @override
  String get vachan1 => 'नाम वह नाव है जो हमें भवसागर से पार ले जाती है।';

  @override
  String get vachan2 => 'प्रेम से जपें, तो हर मनका प्रार्थना बन जाता है।';

  @override
  String get vachan3 => 'जहाँ स्मरण है, वहाँ शांति है।';

  @override
  String get vachan4 =>
      'श्रद्धा से दोहराया गया एक नाम हज़ार विचारों को शांत कर देता है।';

  @override
  String get vachan5 => 'एक माला से आरंभ करें। हर मनके के साथ भक्ति बढ़ती है।';

  @override
  String get vachan6 => 'जो हृदय स्मरण करता है, वह कभी अकेला नहीं होता।';

  @override
  String get vachan7 =>
      'कलियुग केवल नाम अधारा — इस युग में नाम ही हमारा सहारा है।';

  @override
  String get vachan8 =>
      'साँस लें, साँस छोड़ें, और बीच के अंतराल को नाम से भर दें।';

  @override
  String get jaapTitle => 'नाम जाप';

  @override
  String get jaapAddManually => 'गिनती स्वयं जोड़ें';

  @override
  String get jaapUndo => 'पिछला मनका वापस लें';

  @override
  String get jaapTapHint => 'जाप के लिए माला पर कहीं भी स्पर्श करें';

  @override
  String jaapMalaProgress(int mala, int bead, int size) {
    return 'माला $mala  •  $bead/$size';
  }

  @override
  String jaapMalaComplete(int mala, String greeting) {
    return 'माला $mala पूर्ण हुई। $greeting!';
  }

  @override
  String get historyTitle => 'साधना इतिहास';

  @override
  String get historyLog => 'सूची';

  @override
  String get historyCalendar => 'कैलेंडर';

  @override
  String get historyMonth => 'माह';

  @override
  String get historyAddForDay => 'इस दिन की गिनती जोड़ें';

  @override
  String get historyNoJaap => 'इस दिन कोई जाप दर्ज नहीं है।';

  @override
  String get historyLast7Days => 'पिछले 7 दिन';

  @override
  String get historyNaamTotals => 'नाम अनुसार कुल जाप';

  @override
  String get historyNaamTotalsEmpty => 'आपके हर नाम का कुल जाप यहाँ दिखेगा।';

  @override
  String historyEntrySummary(String count, int malas) {
    return '$count जाप  •  $malas माला';
  }

  @override
  String get logAddRecord => 'प्रविष्टि जोड़ें';

  @override
  String get logRecordDeleted => 'प्रविष्टि हटा दी गई';

  @override
  String get logEmptyTitle => 'अपनी जाप सूची शुरू करें';

  @override
  String get logEmptyBody =>
      'जिस दिन भी आप जाप करेंगे, वह दिन अपनी गिनती और अब तक के कुल जाप के साथ यहाँ दिखेगा।';

  @override
  String get syncBadgeSaved => 'Google में सुरक्षित';

  @override
  String get syncBadgeSyncing => 'सिंक हो रहा है…';

  @override
  String get syncBadgePaused => 'सिंक रुका हुआ है';

  @override
  String get syncBadgeOnDevice => 'इस उपकरण पर';

  @override
  String get recordAddTitle => 'जाप प्रविष्टि जोड़ें';

  @override
  String get recordUpdateTitle => 'जाप प्रविष्टि बदलें';

  @override
  String get recordAddSubtitle =>
      'किसी दिन आपने कितनी बार जाप किया, यह दर्ज करें।';

  @override
  String recordUpdateSubtitle(String count) {
    return 'इस दिन पहले से $count दर्ज है। सहेजने पर यह बदल जाएगा।';
  }

  @override
  String get recordDate => 'तारीख़';

  @override
  String get recordAddMore => 'और जोड़ें';

  @override
  String get recordAddMoreHint => 'माला या गिनती यंत्र पर गिना गया जाप';

  @override
  String get recordAddMoreTooltip => 'आज की गिनती में जोड़ें';

  @override
  String get recordTotalUpTo => 'इस दिन तक की कुल गिनती';

  @override
  String get recordSave => 'प्रविष्टि सहेजें';

  @override
  String get recordUpdate => 'प्रविष्टि बदलें';

  @override
  String get recordDelete => 'प्रविष्टि हटाएँ';

  @override
  String get recordCountRequired => 'बताएँ कि आपने कितनी बार जाप किया';

  @override
  String recordCountTooLarge(String max) {
    return 'यह $max से अधिक है';
  }

  @override
  String get recordDeleteTitle => 'यह प्रविष्टि हटाएँ?';

  @override
  String get recordDeleteBody => 'इस दिन की गिनती हटा दी जाएगी।';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsJaap => 'जाप';

  @override
  String get settingsDailyGoal => 'दैनिक लक्ष्य';

  @override
  String settingsDailyGoalValue(String goal) {
    return 'प्रतिदिन $goal जाप';
  }

  @override
  String get settingsCustomGoal => 'अपना लक्ष्य';

  @override
  String get settingsMalaSize => 'माला का आकार';

  @override
  String settingsBeads(int count) {
    return '$count मनके';
  }

  @override
  String get settingsBell => 'माला पूर्ण होने पर घंटी';

  @override
  String get settingsVibrate => 'हर मनके पर कंपन';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsLanguageHint => 'पूरे ऐप की भाषा चुनें।';

  @override
  String get settingsMyNaams => 'मेरे नाम';

  @override
  String get settingsAddOwnNaam => 'अपना नाम जोड़ें';

  @override
  String get settingsAddNaamTitle => 'अपना नाम जोड़ें';

  @override
  String get settingsNaamName => 'नाम';

  @override
  String get settingsNaamNameHint => 'जैसे: सीता राम';

  @override
  String get settingsNaamScript => 'माला पर दिखने वाला नाम (वैकल्पिक)';

  @override
  String get settingsNaamScriptHint => 'जैसे: सीता राम';

  @override
  String get settingsNaamGreeting => 'अभिवादन (वैकल्पिक)';

  @override
  String settingsNaamDefaultGreeting(String naam) {
    return 'जय $naam';
  }

  @override
  String get settingsNaamGreetingHint => 'जैसे: जय सिया राम';

  @override
  String get settingsVoiceThoughts => 'बोलकर विचार';

  @override
  String get settingsSpeechLanguage => 'बोलने की भाषा';

  @override
  String get settingsAppearance => 'रूप-रंग';

  @override
  String get settingsThemeAuto => 'स्वतः';

  @override
  String get settingsThemeDay => 'दिन';

  @override
  String get settingsThemeNight => 'रात';

  @override
  String get settingsAbout => 'परिचय';

  @override
  String settingsAboutBody(String app, String version) {
    return '$app $version\nआपके जाप और विचार इसी उपकरण पर सहेजे जाते हैं। Google बैकअप चालू होने पर आपके जाप की प्रविष्टियाँ आपके Google खाते में भी सुरक्षित रहती हैं।';
  }

  @override
  String get backupTitle => 'Google बैकअप';

  @override
  String get backupUnavailable =>
      'ऐप के इस संस्करण में Google बैकअप उपलब्ध नहीं है।';

  @override
  String get backupIntro =>
      'अपनी जाप प्रविष्टियाँ अपने Google खाते में सुरक्षित रखें। ये आपके सभी उपकरणों पर मिलती रहेंगी और ऐप दोबारा इंस्टॉल करने पर भी वापस आ जाएँगी। इन्हें केवल जापमाला देख सकता है।';

  @override
  String get backupSignIn => 'Google से साइन इन करें';

  @override
  String get backupAccount => 'Google खाता';

  @override
  String get backupReconnect => 'फिर से जोड़ें';

  @override
  String get backupSyncNow => 'अभी सिंक करें';

  @override
  String get backupSignOut => 'साइन आउट करें';

  @override
  String get backupStatusReconnect => 'Google में फिर से साइन इन करना होगा';

  @override
  String get backupStatusFailed => 'पिछला सिंक विफल रहा';

  @override
  String backupStatusSynced(String time) {
    return '$time को सिंक हुआ';
  }

  @override
  String get backupStatusSignedIn => 'साइन इन है';

  @override
  String get syncErrorSignIn =>
      'Google में साइन इन नहीं हो सका। फिर से प्रयास करें।';

  @override
  String get syncErrorDrive => 'Google Drive से संपर्क नहीं हो सका।';

  @override
  String get syncErrorUnreadable =>
      'आपका बैकअप पढ़ा नहीं जा सका। जापमाला अपडेट करके फिर से प्रयास करें।';

  @override
  String get syncErrorGeneric =>
      'सिंक नहीं हो सका। आपकी प्रविष्टियाँ इस उपकरण पर सुरक्षित हैं।';

  @override
  String get thoughtsTitle => 'विचार और चिंतन';

  @override
  String get thoughtNew => 'नया विचार';

  @override
  String get thoughtEdit => 'विचार बदलें';

  @override
  String get thoughtsEmptyTitle => 'आपके चिंतन यहाँ रहेंगे';

  @override
  String thoughtsEmptyBody(String button) {
    return 'जाप के बाद जो अनुभव किया, उसे लिखें या बोलें। शुरू करने के लिए \"$button\" दबाएँ।';
  }

  @override
  String get moodPeaceful => 'शांत';

  @override
  String get moodGrateful => 'कृतज्ञ';

  @override
  String get moodDevoted => 'समर्पित';

  @override
  String get moodJoyful => 'आनंदित';

  @override
  String get moodSeeking => 'जिज्ञासु';

  @override
  String get thoughtHint => 'आज जाप के दौरान आपने क्या अनुभव किया?';

  @override
  String get thoughtSpeechUnavailable =>
      'वाणी पहचान उपलब्ध नहीं है। कृपया माइक्रोफ़ोन और वाणी पहचान की अनुमति दें।';

  @override
  String get thoughtMicNeeded =>
      'आवाज़ रिकॉर्ड करने के लिए माइक्रोफ़ोन की अनुमति आवश्यक है।';

  @override
  String get thoughtEmpty => 'पहले कुछ लिखें, बोलें या रिकॉर्ड करें।';

  @override
  String get thoughtDeleteTitle => 'यह विचार हटाएँ?';

  @override
  String get thoughtDeleteBody =>
      'लिखा हुआ विचार और उसकी रिकॉर्डिंग, दोनों हटा दिए जाएँगे।';

  @override
  String thoughtListening(String language) {
    return '$language में सुन रहे हैं… अब बोलें';
  }

  @override
  String thoughtRecording(String duration) {
    return 'आवाज़ रिकॉर्ड हो रही है  $duration';
  }

  @override
  String get thoughtSpeakToWrite => 'बोलकर लिखें';

  @override
  String get thoughtRecordVoice => 'आवाज़ रिकॉर्ड करें';

  @override
  String get thoughtStopRecording => 'रिकॉर्डिंग रोकें';

  @override
  String get thoughtVoiceHelp =>
      '\"बोलकर लिखें\" आपके शब्दों को लिखित रूप में बदलता है। \"आवाज़ रिकॉर्ड करें\" आपकी अपनी आवाज़ को सहेज लेता है।';

  @override
  String get thoughtSave => 'विचार सहेजें';

  @override
  String get speechLanguageHindi => 'हिन्दी';

  @override
  String get speechLanguageEnglish => 'अंग्रेज़ी';

  @override
  String get voiceNote => 'आवाज़ रिकॉर्डिंग';

  @override
  String get voiceNoteUnavailable => 'आवाज़ रिकॉर्डिंग उपलब्ध नहीं है';

  @override
  String get voiceNoteRemove => 'आवाज़ रिकॉर्डिंग हटाएँ';
}
