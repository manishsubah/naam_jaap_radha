import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:naam_jaap/core/theme/app_colors.dart';
import 'package:naam_jaap/core/widgets/devotional_background.dart';
import 'package:naam_jaap/core/widgets/section_card.dart';
import 'package:naam_jaap/data/models/app_settings.dart';
import 'package:naam_jaap/data/models/naam.dart';
import 'package:naam_jaap/data/providers/providers.dart';
import 'package:naam_jaap/features/settings/presentation/widgets/google_backup_card.dart';
import 'package:naam_jaap/l10n/l10n.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final l10n = context.l10n;
    final numbers = l10n.numbers;
    // What's on screen right now, whether chosen here or taken from the device.
    final currentLanguage = Localizations.localeOf(context).languageCode;

    return DevotionalBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Center(child: Text(l10n.settingsTitle, style: theme.appBarTheme.titleTextStyle)),
            const SizedBox(height: 16),
            SectionCard(
              title: l10n.settingsLanguage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.settingsLanguageHint, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      key: const Key('settings-language'),
                      segments: [
                        for (final e in AppSettings.languages.entries)
                          ButtonSegment(value: e.key, label: Text(e.value)),
                      ],
                      selected: {currentLanguage},
                      // Voice typing follows the app language; it can still be
                      // changed on its own below.
                      onSelectionChanged: (v) => notifier.change((s) => s.copyWith(
                            languageCode: v.first,
                            speechLocale: AppSettings.speechLocaleFor(v.first),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: l10n.settingsJaap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.flag_rounded),
                    title: Text(l10n.settingsDailyGoal),
                    subtitle: Text(l10n.settingsDailyGoalValue(numbers.format(settings.dailyGoal))),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () async {
                      final goal = await _pickGoal(context, settings.dailyGoal);
                      if (goal != null) await notifier.change((s) => s.copyWith(dailyGoal: goal));
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.settingsMalaSize, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<int>(
                      // The tick would push "108 मनके" onto two lines.
                      showSelectedIcon: false,
                      segments: [
                        for (final size in AppSettings.malaSizes)
                          ButtonSegment(value: size, label: Text(l10n.settingsBeads(size))),
                      ],
                      selected: {settings.malaSize},
                      onSelectionChanged: (v) => notifier.change((s) => s.copyWith(malaSize: v.first)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.notifications_active_rounded),
                    title: Text(l10n.settingsBell),
                    value: settings.soundEnabled,
                    onChanged: (v) => notifier.change((s) => s.copyWith(soundEnabled: v)),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.vibration_rounded),
                    title: Text(l10n.settingsVibrate),
                    value: settings.vibrationEnabled,
                    onChanged: (v) => notifier.change((s) => s.copyWith(vibrationEnabled: v)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const GoogleBackupCard(),
            const SizedBox(height: 16),
            SectionCard(title: l10n.settingsMyNaams, child: const _NaamList()),
            const SizedBox(height: 16),
            SectionCard(
              title: l10n.settingsVoiceThoughts,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.settingsSpeechLanguage, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      segments: [
                        for (final e in AppSettings.speechLocales.entries)
                          ButtonSegment(value: e.key, label: Text(e.value)),
                      ],
                      selected: {settings.speechLocale},
                      onSelectionChanged: (v) => notifier.change((s) => s.copyWith(speechLocale: v.first)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: l10n.settingsAppearance,
              child: SizedBox(
                width: double.infinity,
                child: SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: const Icon(Icons.brightness_auto_rounded),
                      label: Text(l10n.settingsThemeAuto),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: const Icon(Icons.wb_sunny_rounded),
                      label: Text(l10n.settingsThemeDay),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: const Icon(Icons.nightlight_round),
                      label: Text(l10n.settingsThemeNight),
                    ),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (v) => notifier.change((s) => s.copyWith(themeMode: v.first)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: l10n.settingsAbout,
              child: Text(
                l10n.settingsAboutBody(l10n.appTitle, '1.0.0'),
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<int?> _pickGoal(BuildContext context, int current) {
    final controller = TextEditingController(text: '$current');
    final l10n = context.l10n;
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsDailyGoal),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final g in AppSettings.goalPresets)
                  ActionChip(label: Text(l10n.numbers.format(g)), onPressed: () => Navigator.pop(context, g)),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(labelText: l10n.settingsCustomGoal),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.commonCancel)),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text) ?? 0;
              Navigator.pop(context, value > 0 ? value : null);
            },
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    ).whenComplete(controller.dispose);
  }
}

class _NaamList extends ConsumerWidget {
  const _NaamList();

  Future<void> _addNaam(BuildContext context, WidgetRef ref) async {
    final name = TextEditingController();
    final script = TextEditingController();
    final greeting = TextEditingController();
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsAddNaamTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: l10n.settingsNaamName, hintText: l10n.settingsNaamNameHint),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: script,
                decoration: InputDecoration(
                  labelText: l10n.settingsNaamScript,
                  hintText: l10n.settingsNaamScriptHint,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: greeting,
                decoration: InputDecoration(
                  labelText: l10n.settingsNaamGreeting,
                  hintText: l10n.settingsNaamGreetingHint,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.commonAdd)),
        ],
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty) {
      final greetingText = greeting.text.trim().isEmpty
          ? l10n.settingsNaamDefaultGreeting(name.text.trim())
          : greeting.text;
      await ref.read(naamsProvider.notifier).add(name: name.text, script: script.text, greeting: greetingText);
    }
    name.dispose();
    script.dispose();
    greeting.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final naams = ref.watch(naamsProvider);
    final selectedId = ref.watch(settingsProvider.select((s) => s.selectedNaamId));
    final l10n = context.l10n;

    return Column(
      children: [
        for (final Naam naam in naams)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: AppColors.gold.withValues(alpha: 0.2),
              child: Text(
                naam.script.characters.first,
                style: const TextStyle(color: AppColors.maroon, fontWeight: FontWeight.w700),
              ),
            ),
            title: Text(l10n.naamName(naam)),
            subtitle: Text(l10n.naamGreeting(naam)),
            onTap: () => ref.read(settingsProvider.notifier).change((s) => s.copyWith(selectedNaamId: naam.id)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (naam.id == selectedId) const Icon(Icons.check_circle_rounded, color: AppColors.kesari),
                if (naam.isCustom && naams.length > 1)
                  IconButton(
                    tooltip: l10n.commonRemove,
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () => ref.read(naamsProvider.notifier).remove(naam.id),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _addNaam(context, ref),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.settingsAddOwnNaam),
          ),
        ),
      ],
    );
  }
}
