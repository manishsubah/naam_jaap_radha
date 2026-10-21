import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({
    this.dailyGoal = 1080,
    this.malaSize = 108,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.themeMode = ThemeMode.system,
    this.speechLocale = 'hi_IN',
    this.selectedNaamId = 'radha',
    this.languageCode,
  });

  final int dailyGoal;
  final int malaSize;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final ThemeMode themeMode;
  final String speechLocale;
  final String selectedNaamId;

  /// App language chosen by the user, one of [languages]. Null follows the
  /// device language.
  final String? languageCode;

  static const malaSizes = [27, 54, 108];
  static const goalPresets = [108, 540, 1080, 2160, 5400, 10800];
  /// Each language is labelled in its own script, so it's recognisable
  /// whichever language the app is currently in.
  static const languages = {'en': 'English', 'hi': 'हिन्दी'};
  static const speechLocales = {'hi_IN': 'हिन्दी', 'en_IN': 'English'};

  /// The speech locale that matches an app language.
  static String speechLocaleFor(String languageCode) => languageCode == 'hi' ? 'hi_IN' : 'en_IN';

  AppSettings copyWith({
    int? dailyGoal,
    int? malaSize,
    bool? soundEnabled,
    bool? vibrationEnabled,
    ThemeMode? themeMode,
    String? speechLocale,
    String? selectedNaamId,
    String? languageCode,
  }) =>
      AppSettings(
        dailyGoal: dailyGoal ?? this.dailyGoal,
        malaSize: malaSize ?? this.malaSize,
        soundEnabled: soundEnabled ?? this.soundEnabled,
        vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
        themeMode: themeMode ?? this.themeMode,
        speechLocale: speechLocale ?? this.speechLocale,
        selectedNaamId: selectedNaamId ?? this.selectedNaamId,
        languageCode: languageCode ?? this.languageCode,
      );

  Map<String, dynamic> toMap() => {
        'dailyGoal': dailyGoal,
        'malaSize': malaSize,
        'soundEnabled': soundEnabled,
        'vibrationEnabled': vibrationEnabled,
        'themeMode': themeMode.name,
        'speechLocale': speechLocale,
        'selectedNaamId': selectedNaamId,
        'languageCode': languageCode,
      };

  factory AppSettings.fromMap(Map<dynamic, dynamic> map) {
    const d = AppSettings();
    final mode = map['themeMode'] as String?;
    return AppSettings(
      dailyGoal: map['dailyGoal'] as int? ?? d.dailyGoal,
      malaSize: map['malaSize'] as int? ?? d.malaSize,
      soundEnabled: map['soundEnabled'] as bool? ?? d.soundEnabled,
      vibrationEnabled: map['vibrationEnabled'] as bool? ?? d.vibrationEnabled,
      themeMode: ThemeMode.values.where((m) => m.name == mode).firstOrNull ?? d.themeMode,
      speechLocale: map['speechLocale'] as String? ?? d.speechLocale,
      selectedNaamId: map['selectedNaamId'] as String? ?? d.selectedNaamId,
      languageCode: languages.containsKey(map['languageCode']) ? map['languageCode'] as String : null,
    );
  }
}
