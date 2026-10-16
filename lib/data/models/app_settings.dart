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
  });

  final int dailyGoal;
  final int malaSize;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final ThemeMode themeMode;
  final String speechLocale;
  final String selectedNaamId;

  static const malaSizes = [27, 54, 108];
  static const goalPresets = [108, 540, 1080, 2160, 5400, 10800];
  static const speechLocales = {'hi_IN': 'हिन्दी', 'en_IN': 'English'};

  AppSettings copyWith({
    int? dailyGoal,
    int? malaSize,
    bool? soundEnabled,
    bool? vibrationEnabled,
    ThemeMode? themeMode,
    String? speechLocale,
    String? selectedNaamId,
  }) =>
      AppSettings(
        dailyGoal: dailyGoal ?? this.dailyGoal,
        malaSize: malaSize ?? this.malaSize,
        soundEnabled: soundEnabled ?? this.soundEnabled,
        vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
        themeMode: themeMode ?? this.themeMode,
        speechLocale: speechLocale ?? this.speechLocale,
        selectedNaamId: selectedNaamId ?? this.selectedNaamId,
      );

  Map<String, dynamic> toMap() => {
        'dailyGoal': dailyGoal,
        'malaSize': malaSize,
        'soundEnabled': soundEnabled,
        'vibrationEnabled': vibrationEnabled,
        'themeMode': themeMode.name,
        'speechLocale': speechLocale,
        'selectedNaamId': selectedNaamId,
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
    );
  }
}
