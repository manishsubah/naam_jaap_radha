// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'JaapMala';

  @override
  String get navHome => 'Home';

  @override
  String get navJaap => 'Jaap';

  @override
  String get navHistory => 'History';

  @override
  String get navThoughts => 'Thoughts';

  @override
  String get navSettings => 'Settings';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonStop => 'Stop';

  @override
  String get commonAll => 'All';

  @override
  String get commonTotal => 'Total';

  @override
  String get commonToday => 'today';

  @override
  String get removedNaam => 'Removed naam';

  @override
  String get jaapName => 'Jaap name';

  @override
  String get todaysCount => 'Today\'s count';

  @override
  String jaapCount(String count) {
    return '$count jaap';
  }

  @override
  String get naamRadha => 'Radha';

  @override
  String get naamRam => 'Ram';

  @override
  String get naamSitaRam => 'Sita-Ram';

  @override
  String get naamKrishna => 'Krishna';

  @override
  String get naamShiv => 'Om Namah Shivaya';

  @override
  String get naamHanuman => 'Hanuman';

  @override
  String get naamOm => 'Om';

  @override
  String get naamWaheguru => 'Waheguru';

  @override
  String get greetingRadha => 'Radhe Radhe';

  @override
  String get greetingRam => 'Jai Shri Ram';

  @override
  String get greetingSitaRam => 'Jai Siya Ram';

  @override
  String get greetingKrishna => 'Hare Krishna';

  @override
  String get greetingShiv => 'Har Har Mahadev';

  @override
  String get greetingHanuman => 'Jai Bajrangbali';

  @override
  String get greetingOm => 'Om Shanti';

  @override
  String get greetingWaheguru => 'Waheguru Ji';

  @override
  String homeGoalProgress(String goal) {
    return 'of $goal today';
  }

  @override
  String homeStartJaap(String naam) {
    return 'Start $naam Jaap';
  }

  @override
  String homeStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days streak',
      one: 'day streak',
    );
    return '$_temp0';
  }

  @override
  String get homeMalasToday => 'malas today';

  @override
  String get homeLifetime => 'lifetime';

  @override
  String get homeVachanTitle => 'Today\'s teaching';

  @override
  String get homeCaptureThought => 'Capture a thought';

  @override
  String get homeLatestThought => 'Latest thought';

  @override
  String get homeCaptureHint =>
      'Write or speak what is in your heart after your jaap.';

  @override
  String get vachan1 =>
      'The Name is the boat that carries us across the ocean of life.';

  @override
  String get vachan2 => 'Chant with love, and every bead becomes a prayer.';

  @override
  String get vachan3 => 'Where there is remembrance, there is peace.';

  @override
  String get vachan4 =>
      'One name, repeated with faith, can quiet a thousand thoughts.';

  @override
  String get vachan5 => 'Begin with one mala. Devotion grows with every bead.';

  @override
  String get vachan6 => 'The heart that remembers is never alone.';

  @override
  String get vachan7 => 'In this age, the Name alone is our support.';

  @override
  String get vachan8 =>
      'Breathe in, breathe out, and let the Name fill the space between.';

  @override
  String get jaapTitle => 'Naam Jaap';

  @override
  String get jaapAddManually => 'Add count manually';

  @override
  String get jaapUndo => 'Undo last bead';

  @override
  String get jaapTapHint => 'Tap anywhere on the mala to chant';

  @override
  String jaapMalaProgress(int mala, int bead, int size) {
    return 'Mala $mala  •  $bead/$size';
  }

  @override
  String jaapMalaComplete(int mala, String greeting) {
    return 'Mala $mala complete. $greeting!';
  }

  @override
  String get historyTitle => 'Sadhana History';

  @override
  String get historyLog => 'Log';

  @override
  String get historyCalendar => 'Calendar';

  @override
  String get historyMonth => 'Month';

  @override
  String get historyAddForDay => 'Add count for this day';

  @override
  String get historyNoJaap => 'No jaap recorded on this day.';

  @override
  String get historyLast7Days => 'Last 7 days';

  @override
  String get historyNaamTotals => 'Naam totals';

  @override
  String get historyNaamTotalsEmpty => 'Your naam totals will appear here.';

  @override
  String historyEntrySummary(String count, int malas) {
    return '$count jaap  •  $malas malas';
  }

  @override
  String get logAddRecord => 'Add record';

  @override
  String get logRecordDeleted => 'Record deleted';

  @override
  String get logEmptyTitle => 'Start your jaap log';

  @override
  String get logEmptyBody =>
      'Each day you chant appears here with its count and your running total.';

  @override
  String get syncBadgeSaved => 'Saved to Google';

  @override
  String get syncBadgeSyncing => 'Syncing…';

  @override
  String get syncBadgePaused => 'Sync paused';

  @override
  String get syncBadgeOnDevice => 'On this device';

  @override
  String get recordAddTitle => 'Add jaap record';

  @override
  String get recordUpdateTitle => 'Update jaap record';

  @override
  String get recordAddSubtitle => 'Record how many times you chanted on a day.';

  @override
  String recordUpdateSubtitle(String count) {
    return 'This day already has $count. Saving replaces it.';
  }

  @override
  String get recordDate => 'Date';

  @override
  String get recordAddMore => 'Add more';

  @override
  String get recordAddMoreHint => 'Counted on a mala or counter';

  @override
  String get recordAddMoreTooltip => 'Add to today\'s count';

  @override
  String get recordTotalUpTo => 'Total count up to this day';

  @override
  String get recordSave => 'Save record';

  @override
  String get recordUpdate => 'Update record';

  @override
  String get recordDelete => 'Delete record';

  @override
  String get recordCountRequired => 'Enter how many times you chanted';

  @override
  String recordCountTooLarge(String max) {
    return 'That is more than $max';
  }

  @override
  String get recordDeleteTitle => 'Delete this record?';

  @override
  String get recordDeleteBody => 'The count for this day will be removed.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsJaap => 'Jaap';

  @override
  String get settingsDailyGoal => 'Daily goal';

  @override
  String settingsDailyGoalValue(String goal) {
    return '$goal jaap per day';
  }

  @override
  String get settingsCustomGoal => 'Custom goal';

  @override
  String get settingsMalaSize => 'Mala size';

  @override
  String settingsBeads(int count) {
    return '$count beads';
  }

  @override
  String get settingsBell => 'Temple bell on mala complete';

  @override
  String get settingsVibrate => 'Vibrate on each bead';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageHint => 'Choose the language for the whole app.';

  @override
  String get settingsMyNaams => 'My naams';

  @override
  String get settingsAddOwnNaam => 'Add your own naam';

  @override
  String get settingsAddNaamTitle => 'Add your naam';

  @override
  String get settingsNaamName => 'Name';

  @override
  String get settingsNaamNameHint => 'e.g. Sita Ram';

  @override
  String get settingsNaamScript => 'Shown on mala (optional)';

  @override
  String get settingsNaamScriptHint => 'e.g. सीता राम';

  @override
  String get settingsNaamGreeting => 'Greeting (optional)';

  @override
  String settingsNaamDefaultGreeting(String naam) {
    return 'Jai $naam';
  }

  @override
  String get settingsNaamGreetingHint => 'e.g. Jai Siya Ram';

  @override
  String get settingsVoiceThoughts => 'Voice thoughts';

  @override
  String get settingsSpeechLanguage => 'Speech language';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeAuto => 'Auto';

  @override
  String get settingsThemeDay => 'Day';

  @override
  String get settingsThemeNight => 'Night';

  @override
  String get settingsAbout => 'About';

  @override
  String settingsAboutBody(String app, String version) {
    return '$app $version\nYour jaap and thoughts are stored on this device. With Google backup on, your jaap records are also kept in your Google account.';
  }

  @override
  String get backupTitle => 'Google backup';

  @override
  String get backupUnavailable =>
      'Google backup is not set up in this build of the app.';

  @override
  String get backupIntro =>
      'Keep your jaap records safe in your Google account. They sync across your devices and come back if you reinstall. Only JaapMala can see them.';

  @override
  String get backupSignIn => 'Sign in with Google';

  @override
  String get backupAccount => 'Google account';

  @override
  String get backupReconnect => 'Reconnect';

  @override
  String get backupSyncNow => 'Sync now';

  @override
  String get backupSignOut => 'Sign out';

  @override
  String get backupStatusReconnect => 'Google needs you to sign in again';

  @override
  String get backupStatusFailed => 'Last sync failed';

  @override
  String backupStatusSynced(String time) {
    return 'Synced $time';
  }

  @override
  String get backupStatusSignedIn => 'Signed in';

  @override
  String get syncErrorSignIn => 'Couldn\'t sign in to Google. Try again.';

  @override
  String get syncErrorDrive => 'Couldn\'t reach Google Drive.';

  @override
  String get syncErrorUnreadable =>
      'Your backup couldn\'t be read. Update JaapMala and try again.';

  @override
  String get syncErrorGeneric =>
      'Couldn\'t sync. Your records are safe on this device.';

  @override
  String get thoughtsTitle => 'Thoughts & Reflections';

  @override
  String get thoughtNew => 'New thought';

  @override
  String get thoughtEdit => 'Edit thought';

  @override
  String get thoughtsEmptyTitle => 'Your reflections live here';

  @override
  String thoughtsEmptyBody(String button) {
    return 'After your jaap, write or speak what you felt. Tap \"$button\" to begin.';
  }

  @override
  String get moodPeaceful => 'Peaceful';

  @override
  String get moodGrateful => 'Grateful';

  @override
  String get moodDevoted => 'Devoted';

  @override
  String get moodJoyful => 'Joyful';

  @override
  String get moodSeeking => 'Seeking';

  @override
  String get thoughtHint => 'What did you feel during your jaap today?';

  @override
  String get thoughtSpeechUnavailable =>
      'Speech recognition is not available. Please allow microphone and speech access.';

  @override
  String get thoughtMicNeeded =>
      'Microphone permission is needed to record a voice note.';

  @override
  String get thoughtEmpty => 'Write, speak, or record something first.';

  @override
  String get thoughtDeleteTitle => 'Delete this thought?';

  @override
  String get thoughtDeleteBody =>
      'The text and any voice note will be removed.';

  @override
  String thoughtListening(String language) {
    return 'Listening in $language… speak now';
  }

  @override
  String thoughtRecording(String duration) {
    return 'Recording voice note  $duration';
  }

  @override
  String get thoughtSpeakToWrite => 'Speak to write';

  @override
  String get thoughtRecordVoice => 'Record voice';

  @override
  String get thoughtStopRecording => 'Stop recording';

  @override
  String get thoughtVoiceHelp =>
      'Speak to write turns your words into text. Record voice saves your own voice as a note.';

  @override
  String get thoughtSave => 'Save thought';

  @override
  String get speechLanguageHindi => 'Hindi';

  @override
  String get speechLanguageEnglish => 'English';

  @override
  String get voiceNote => 'Voice note';

  @override
  String get voiceNoteUnavailable => 'Voice note unavailable';

  @override
  String get voiceNoteRemove => 'Remove voice note';
}
