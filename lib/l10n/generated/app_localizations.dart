import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('hi'),
  ];

  /// App name, shown in the task switcher and About.
  ///
  /// In en, this message translates to:
  /// **'JaapMala'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navJaap.
  ///
  /// In en, this message translates to:
  /// **'Jaap'**
  String get navJaap;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navThoughts.
  ///
  /// In en, this message translates to:
  /// **'Thoughts'**
  String get navThoughts;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get commonUndo;

  /// No description provided for @commonStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get commonStop;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get commonTotal;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get commonToday;

  /// No description provided for @removedNaam.
  ///
  /// In en, this message translates to:
  /// **'Removed naam'**
  String get removedNaam;

  /// No description provided for @jaapName.
  ///
  /// In en, this message translates to:
  /// **'Jaap name'**
  String get jaapName;

  /// No description provided for @todaysCount.
  ///
  /// In en, this message translates to:
  /// **'Today\'s count'**
  String get todaysCount;

  /// No description provided for @jaapCount.
  ///
  /// In en, this message translates to:
  /// **'{count} jaap'**
  String jaapCount(String count);

  /// No description provided for @naamRadha.
  ///
  /// In en, this message translates to:
  /// **'Radha'**
  String get naamRadha;

  /// No description provided for @naamRam.
  ///
  /// In en, this message translates to:
  /// **'Ram'**
  String get naamRam;

  /// No description provided for @naamSitaRam.
  ///
  /// In en, this message translates to:
  /// **'Sita-Ram'**
  String get naamSitaRam;

  /// No description provided for @naamKrishna.
  ///
  /// In en, this message translates to:
  /// **'Krishna'**
  String get naamKrishna;

  /// No description provided for @naamShiv.
  ///
  /// In en, this message translates to:
  /// **'Om Namah Shivaya'**
  String get naamShiv;

  /// No description provided for @naamHanuman.
  ///
  /// In en, this message translates to:
  /// **'Hanuman'**
  String get naamHanuman;

  /// No description provided for @naamOm.
  ///
  /// In en, this message translates to:
  /// **'Om'**
  String get naamOm;

  /// No description provided for @naamWaheguru.
  ///
  /// In en, this message translates to:
  /// **'Waheguru'**
  String get naamWaheguru;

  /// No description provided for @greetingRadha.
  ///
  /// In en, this message translates to:
  /// **'Radhe Radhe'**
  String get greetingRadha;

  /// No description provided for @greetingRam.
  ///
  /// In en, this message translates to:
  /// **'Jai Shri Ram'**
  String get greetingRam;

  /// No description provided for @greetingSitaRam.
  ///
  /// In en, this message translates to:
  /// **'Jai Siya Ram'**
  String get greetingSitaRam;

  /// No description provided for @greetingKrishna.
  ///
  /// In en, this message translates to:
  /// **'Hare Krishna'**
  String get greetingKrishna;

  /// No description provided for @greetingShiv.
  ///
  /// In en, this message translates to:
  /// **'Har Har Mahadev'**
  String get greetingShiv;

  /// No description provided for @greetingHanuman.
  ///
  /// In en, this message translates to:
  /// **'Jai Bajrangbali'**
  String get greetingHanuman;

  /// No description provided for @greetingOm.
  ///
  /// In en, this message translates to:
  /// **'Om Shanti'**
  String get greetingOm;

  /// No description provided for @greetingWaheguru.
  ///
  /// In en, this message translates to:
  /// **'Waheguru Ji'**
  String get greetingWaheguru;

  /// No description provided for @homeGoalProgress.
  ///
  /// In en, this message translates to:
  /// **'of {goal} today'**
  String homeGoalProgress(String goal);

  /// No description provided for @homeStartJaap.
  ///
  /// In en, this message translates to:
  /// **'Start {naam} Jaap'**
  String homeStartJaap(String naam);

  /// No description provided for @homeStreak.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{day streak} other{days streak}}'**
  String homeStreak(int count);

  /// No description provided for @homeMalasToday.
  ///
  /// In en, this message translates to:
  /// **'malas today'**
  String get homeMalasToday;

  /// No description provided for @homeLifetime.
  ///
  /// In en, this message translates to:
  /// **'lifetime'**
  String get homeLifetime;

  /// No description provided for @homeVachanTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s teaching'**
  String get homeVachanTitle;

  /// No description provided for @homeCaptureThought.
  ///
  /// In en, this message translates to:
  /// **'Capture a thought'**
  String get homeCaptureThought;

  /// No description provided for @homeLatestThought.
  ///
  /// In en, this message translates to:
  /// **'Latest thought'**
  String get homeLatestThought;

  /// No description provided for @homeCaptureHint.
  ///
  /// In en, this message translates to:
  /// **'Write or speak what is in your heart after your jaap.'**
  String get homeCaptureHint;

  /// No description provided for @vachan1.
  ///
  /// In en, this message translates to:
  /// **'The Name is the boat that carries us across the ocean of life.'**
  String get vachan1;

  /// No description provided for @vachan2.
  ///
  /// In en, this message translates to:
  /// **'Chant with love, and every bead becomes a prayer.'**
  String get vachan2;

  /// No description provided for @vachan3.
  ///
  /// In en, this message translates to:
  /// **'Where there is remembrance, there is peace.'**
  String get vachan3;

  /// No description provided for @vachan4.
  ///
  /// In en, this message translates to:
  /// **'One name, repeated with faith, can quiet a thousand thoughts.'**
  String get vachan4;

  /// No description provided for @vachan5.
  ///
  /// In en, this message translates to:
  /// **'Begin with one mala. Devotion grows with every bead.'**
  String get vachan5;

  /// No description provided for @vachan6.
  ///
  /// In en, this message translates to:
  /// **'The heart that remembers is never alone.'**
  String get vachan6;

  /// No description provided for @vachan7.
  ///
  /// In en, this message translates to:
  /// **'In this age, the Name alone is our support.'**
  String get vachan7;

  /// No description provided for @vachan8.
  ///
  /// In en, this message translates to:
  /// **'Breathe in, breathe out, and let the Name fill the space between.'**
  String get vachan8;

  /// No description provided for @jaapTitle.
  ///
  /// In en, this message translates to:
  /// **'Naam Jaap'**
  String get jaapTitle;

  /// No description provided for @jaapAddManually.
  ///
  /// In en, this message translates to:
  /// **'Add count manually'**
  String get jaapAddManually;

  /// No description provided for @jaapUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo last bead'**
  String get jaapUndo;

  /// No description provided for @jaapTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere on the mala to chant'**
  String get jaapTapHint;

  /// No description provided for @jaapMalaProgress.
  ///
  /// In en, this message translates to:
  /// **'Mala {mala}  •  {bead}/{size}'**
  String jaapMalaProgress(int mala, int bead, int size);

  /// No description provided for @jaapMalaComplete.
  ///
  /// In en, this message translates to:
  /// **'Mala {mala} complete. {greeting}!'**
  String jaapMalaComplete(int mala, String greeting);

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Sadhana History'**
  String get historyTitle;

  /// No description provided for @historyLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get historyLog;

  /// No description provided for @historyCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get historyCalendar;

  /// No description provided for @historyMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get historyMonth;

  /// No description provided for @historyAddForDay.
  ///
  /// In en, this message translates to:
  /// **'Add count for this day'**
  String get historyAddForDay;

  /// No description provided for @historyNoJaap.
  ///
  /// In en, this message translates to:
  /// **'No jaap recorded on this day.'**
  String get historyNoJaap;

  /// No description provided for @historyLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get historyLast7Days;

  /// No description provided for @historyNaamTotals.
  ///
  /// In en, this message translates to:
  /// **'Naam totals'**
  String get historyNaamTotals;

  /// No description provided for @historyNaamTotalsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your naam totals will appear here.'**
  String get historyNaamTotalsEmpty;

  /// No description provided for @historyEntrySummary.
  ///
  /// In en, this message translates to:
  /// **'{count} jaap  •  {malas} malas'**
  String historyEntrySummary(String count, int malas);

  /// No description provided for @logAddRecord.
  ///
  /// In en, this message translates to:
  /// **'Add record'**
  String get logAddRecord;

  /// No description provided for @logRecordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Record deleted'**
  String get logRecordDeleted;

  /// No description provided for @logEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Start your jaap log'**
  String get logEmptyTitle;

  /// No description provided for @logEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Each day you chant appears here with its count and your running total.'**
  String get logEmptyBody;

  /// No description provided for @syncBadgeSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to Google'**
  String get syncBadgeSaved;

  /// No description provided for @syncBadgeSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get syncBadgeSyncing;

  /// No description provided for @syncBadgePaused.
  ///
  /// In en, this message translates to:
  /// **'Sync paused'**
  String get syncBadgePaused;

  /// No description provided for @syncBadgeOnDevice.
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get syncBadgeOnDevice;

  /// No description provided for @recordAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add jaap record'**
  String get recordAddTitle;

  /// No description provided for @recordUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update jaap record'**
  String get recordUpdateTitle;

  /// No description provided for @recordAddSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record how many times you chanted on a day.'**
  String get recordAddSubtitle;

  /// No description provided for @recordUpdateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This day already has {count}. Saving replaces it.'**
  String recordUpdateSubtitle(String count);

  /// No description provided for @recordDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get recordDate;

  /// No description provided for @recordAddMore.
  ///
  /// In en, this message translates to:
  /// **'Add more'**
  String get recordAddMore;

  /// No description provided for @recordAddMoreHint.
  ///
  /// In en, this message translates to:
  /// **'Counted on a mala or counter'**
  String get recordAddMoreHint;

  /// No description provided for @recordAddMoreTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add to today\'s count'**
  String get recordAddMoreTooltip;

  /// No description provided for @recordTotalUpTo.
  ///
  /// In en, this message translates to:
  /// **'Total count up to this day'**
  String get recordTotalUpTo;

  /// No description provided for @recordSave.
  ///
  /// In en, this message translates to:
  /// **'Save record'**
  String get recordSave;

  /// No description provided for @recordUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update record'**
  String get recordUpdate;

  /// No description provided for @recordDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete record'**
  String get recordDelete;

  /// No description provided for @recordCountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter how many times you chanted'**
  String get recordCountRequired;

  /// No description provided for @recordCountTooLarge.
  ///
  /// In en, this message translates to:
  /// **'That is more than {max}'**
  String recordCountTooLarge(String max);

  /// No description provided for @recordDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this record?'**
  String get recordDeleteTitle;

  /// No description provided for @recordDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'The count for this day will be removed.'**
  String get recordDeleteBody;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsJaap.
  ///
  /// In en, this message translates to:
  /// **'Jaap'**
  String get settingsJaap;

  /// No description provided for @settingsDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get settingsDailyGoal;

  /// No description provided for @settingsDailyGoalValue.
  ///
  /// In en, this message translates to:
  /// **'{goal} jaap per day'**
  String settingsDailyGoalValue(String goal);

  /// No description provided for @settingsCustomGoal.
  ///
  /// In en, this message translates to:
  /// **'Custom goal'**
  String get settingsCustomGoal;

  /// No description provided for @settingsMalaSize.
  ///
  /// In en, this message translates to:
  /// **'Mala size'**
  String get settingsMalaSize;

  /// No description provided for @settingsBeads.
  ///
  /// In en, this message translates to:
  /// **'{count} beads'**
  String settingsBeads(int count);

  /// No description provided for @settingsBell.
  ///
  /// In en, this message translates to:
  /// **'Temple bell on mala complete'**
  String get settingsBell;

  /// No description provided for @settingsVibrate.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on each bead'**
  String get settingsVibrate;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the language for the whole app.'**
  String get settingsLanguageHint;

  /// No description provided for @settingsMyNaams.
  ///
  /// In en, this message translates to:
  /// **'My naams'**
  String get settingsMyNaams;

  /// No description provided for @settingsAddOwnNaam.
  ///
  /// In en, this message translates to:
  /// **'Add your own naam'**
  String get settingsAddOwnNaam;

  /// No description provided for @settingsAddNaamTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your naam'**
  String get settingsAddNaamTitle;

  /// No description provided for @settingsNaamName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get settingsNaamName;

  /// No description provided for @settingsNaamNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Sita Ram'**
  String get settingsNaamNameHint;

  /// No description provided for @settingsNaamScript.
  ///
  /// In en, this message translates to:
  /// **'Shown on mala (optional)'**
  String get settingsNaamScript;

  /// No description provided for @settingsNaamScriptHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. सीता राम'**
  String get settingsNaamScriptHint;

  /// No description provided for @settingsNaamGreeting.
  ///
  /// In en, this message translates to:
  /// **'Greeting (optional)'**
  String get settingsNaamGreeting;

  /// Greeting used when the user leaves it blank.
  ///
  /// In en, this message translates to:
  /// **'Jai {naam}'**
  String settingsNaamDefaultGreeting(String naam);

  /// No description provided for @settingsNaamGreetingHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Jai Siya Ram'**
  String get settingsNaamGreetingHint;

  /// No description provided for @settingsVoiceThoughts.
  ///
  /// In en, this message translates to:
  /// **'Voice thoughts'**
  String get settingsVoiceThoughts;

  /// No description provided for @settingsSpeechLanguage.
  ///
  /// In en, this message translates to:
  /// **'Speech language'**
  String get settingsSpeechLanguage;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get settingsThemeAuto;

  /// No description provided for @settingsThemeDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get settingsThemeDay;

  /// No description provided for @settingsThemeNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get settingsThemeNight;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'{app} {version}\nYour jaap and thoughts are stored on this device. With Google backup on, your jaap records are also kept in your Google account.'**
  String settingsAboutBody(String app, String version);

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Google backup'**
  String get backupTitle;

  /// No description provided for @backupUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Google backup is not set up in this build of the app.'**
  String get backupUnavailable;

  /// No description provided for @backupIntro.
  ///
  /// In en, this message translates to:
  /// **'Keep your jaap records safe in your Google account. They sync across your devices and come back if you reinstall. Only JaapMala can see them.'**
  String get backupIntro;

  /// No description provided for @backupSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get backupSignIn;

  /// No description provided for @backupAccount.
  ///
  /// In en, this message translates to:
  /// **'Google account'**
  String get backupAccount;

  /// No description provided for @backupReconnect.
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get backupReconnect;

  /// No description provided for @backupSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get backupSyncNow;

  /// No description provided for @backupSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get backupSignOut;

  /// No description provided for @backupStatusReconnect.
  ///
  /// In en, this message translates to:
  /// **'Google needs you to sign in again'**
  String get backupStatusReconnect;

  /// No description provided for @backupStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Last sync failed'**
  String get backupStatusFailed;

  /// No description provided for @backupStatusSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced {time}'**
  String backupStatusSynced(String time);

  /// No description provided for @backupStatusSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get backupStatusSignedIn;

  /// No description provided for @syncErrorSignIn.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sign in to Google. Try again.'**
  String get syncErrorSignIn;

  /// No description provided for @syncErrorDrive.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach Google Drive.'**
  String get syncErrorDrive;

  /// No description provided for @syncErrorUnreadable.
  ///
  /// In en, this message translates to:
  /// **'Your backup couldn\'t be read. Update JaapMala and try again.'**
  String get syncErrorUnreadable;

  /// No description provided for @syncErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sync. Your records are safe on this device.'**
  String get syncErrorGeneric;

  /// No description provided for @thoughtsTitle.
  ///
  /// In en, this message translates to:
  /// **'Thoughts & Reflections'**
  String get thoughtsTitle;

  /// No description provided for @thoughtNew.
  ///
  /// In en, this message translates to:
  /// **'New thought'**
  String get thoughtNew;

  /// No description provided for @thoughtEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit thought'**
  String get thoughtEdit;

  /// No description provided for @thoughtsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your reflections live here'**
  String get thoughtsEmptyTitle;

  /// No description provided for @thoughtsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'After your jaap, write or speak what you felt. Tap \"{button}\" to begin.'**
  String thoughtsEmptyBody(String button);

  /// No description provided for @moodPeaceful.
  ///
  /// In en, this message translates to:
  /// **'Peaceful'**
  String get moodPeaceful;

  /// No description provided for @moodGrateful.
  ///
  /// In en, this message translates to:
  /// **'Grateful'**
  String get moodGrateful;

  /// No description provided for @moodDevoted.
  ///
  /// In en, this message translates to:
  /// **'Devoted'**
  String get moodDevoted;

  /// No description provided for @moodJoyful.
  ///
  /// In en, this message translates to:
  /// **'Joyful'**
  String get moodJoyful;

  /// No description provided for @moodSeeking.
  ///
  /// In en, this message translates to:
  /// **'Seeking'**
  String get moodSeeking;

  /// No description provided for @thoughtHint.
  ///
  /// In en, this message translates to:
  /// **'What did you feel during your jaap today?'**
  String get thoughtHint;

  /// No description provided for @thoughtSpeechUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available. Please allow microphone and speech access.'**
  String get thoughtSpeechUnavailable;

  /// No description provided for @thoughtMicNeeded.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is needed to record a voice note.'**
  String get thoughtMicNeeded;

  /// No description provided for @thoughtEmpty.
  ///
  /// In en, this message translates to:
  /// **'Write, speak, or record something first.'**
  String get thoughtEmpty;

  /// No description provided for @thoughtDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this thought?'**
  String get thoughtDeleteTitle;

  /// No description provided for @thoughtDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'The text and any voice note will be removed.'**
  String get thoughtDeleteBody;

  /// No description provided for @thoughtListening.
  ///
  /// In en, this message translates to:
  /// **'Listening in {language}… speak now'**
  String thoughtListening(String language);

  /// No description provided for @thoughtRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording voice note  {duration}'**
  String thoughtRecording(String duration);

  /// No description provided for @thoughtSpeakToWrite.
  ///
  /// In en, this message translates to:
  /// **'Speak to write'**
  String get thoughtSpeakToWrite;

  /// No description provided for @thoughtRecordVoice.
  ///
  /// In en, this message translates to:
  /// **'Record voice'**
  String get thoughtRecordVoice;

  /// No description provided for @thoughtStopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get thoughtStopRecording;

  /// No description provided for @thoughtVoiceHelp.
  ///
  /// In en, this message translates to:
  /// **'Speak to write turns your words into text. Record voice saves your own voice as a note.'**
  String get thoughtVoiceHelp;

  /// No description provided for @thoughtSave.
  ///
  /// In en, this message translates to:
  /// **'Save thought'**
  String get thoughtSave;

  /// No description provided for @speechLanguageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get speechLanguageHindi;

  /// No description provided for @speechLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get speechLanguageEnglish;

  /// No description provided for @voiceNote.
  ///
  /// In en, this message translates to:
  /// **'Voice note'**
  String get voiceNote;

  /// No description provided for @voiceNoteUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice note unavailable'**
  String get voiceNoteUnavailable;

  /// No description provided for @voiceNoteRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove voice note'**
  String get voiceNoteRemove;
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
