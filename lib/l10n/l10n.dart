import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:naam_jaap/data/models/naam.dart';
import 'package:naam_jaap/data/models/thought.dart';
import 'package:naam_jaap/l10n/generated/app_localizations.dart';

export 'package:naam_jaap/l10n/generated/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Locale-aware formatting and lookups for values that live in data models.
extension L10nFormats on AppLocalizations {
  /// Indian digit grouping (1,00,000) in both languages.
  NumberFormat get numbers => NumberFormat.decimalPattern(_numberLocale);

  /// Short form for large counts: 4.52L in English, 4.52 लाख in Hindi.
  NumberFormat get compactNumbers => NumberFormat.compact(locale: _numberLocale);

  String get _numberLocale => localeName == 'hi' ? 'hi' : 'en_IN';

  String formatDate(String pattern, DateTime date) => DateFormat(pattern, localeName).format(date);

  List<String> get vachans => [vachan1, vachan2, vachan3, vachan4, vachan5, vachan6, vachan7, vachan8];

  /// Built-in naams are shown in the app's language; the user's own naams
  /// are shown exactly as they typed them.
  String naamName(Naam naam) => switch (naam.isCustom ? null : naam.id) {
        'radha' => naamRadha,
        'ram' => naamRam,
        'sitaram' => naamSitaRam,
        'krishna' => naamKrishna,
        'shiv' => naamShiv,
        'hanuman' => naamHanuman,
        'om' => naamOm,
        'waheguru' => naamWaheguru,
        _ => naam.name,
      };

  String naamGreeting(Naam naam) => switch (naam.isCustom ? null : naam.id) {
        'radha' => greetingRadha,
        'ram' => greetingRam,
        'sitaram' => greetingSitaRam,
        'krishna' => greetingKrishna,
        'shiv' => greetingShiv,
        'hanuman' => greetingHanuman,
        'om' => greetingOm,
        'waheguru' => greetingWaheguru,
        _ => naam.greeting,
      };

  String moodLabel(ThoughtMood mood) => switch (mood) {
        ThoughtMood.peaceful => moodPeaceful,
        ThoughtMood.grateful => moodGrateful,
        ThoughtMood.devoted => moodDevoted,
        ThoughtMood.joyful => moodJoyful,
        ThoughtMood.seeking => moodSeeking,
      };

  String speechLanguageName(String localeId) =>
      localeId.startsWith('hi') ? speechLanguageHindi : speechLanguageEnglish;
}
