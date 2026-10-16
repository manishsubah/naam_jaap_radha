import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:naam_jaap/core/theme/app_colors.dart';
import 'package:naam_jaap/core/widgets/devotional_background.dart';
import 'package:naam_jaap/core/widgets/section_card.dart';
import 'package:naam_jaap/data/models/app_settings.dart';
import 'package:naam_jaap/data/models/naam.dart';
import 'package:naam_jaap/data/providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final numbers = NumberFormat.decimalPattern('en_IN');

    return DevotionalBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Center(child: Text('Settings', style: theme.appBarTheme.titleTextStyle)),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Jaap',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.flag_rounded),
                    title: const Text('Daily goal'),
                    subtitle: Text('${numbers.format(settings.dailyGoal)} jaap per day'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () async {
                      final goal = await _pickGoal(context, settings.dailyGoal);
                      if (goal != null) await notifier.change((s) => s.copyWith(dailyGoal: goal));
                    },
                  ),
                  const SizedBox(height: 8),
                  Text('Mala size', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<int>(
                      segments: [
                        for (final size in AppSettings.malaSizes)
                          ButtonSegment(value: size, label: Text('$size beads')),
                      ],
                      selected: {settings.malaSize},
                      onSelectionChanged: (v) => notifier.change((s) => s.copyWith(malaSize: v.first)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.notifications_active_rounded),
                    title: const Text('Temple bell on mala complete'),
                    value: settings.soundEnabled,
                    onChanged: (v) => notifier.change((s) => s.copyWith(soundEnabled: v)),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.vibration_rounded),
                    title: const Text('Vibrate on each bead'),
                    value: settings.vibrationEnabled,
                    onChanged: (v) => notifier.change((s) => s.copyWith(vibrationEnabled: v)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionCard(title: 'My naams', child: _NaamList()),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Voice thoughts',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Speech language', style: theme.textTheme.titleSmall),
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
              title: 'Appearance',
              child: SizedBox(
                width: double.infinity,
                child: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto_rounded), label: Text('Auto')),
                    ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.wb_sunny_rounded), label: Text('Day')),
                    ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.nightlight_round), label: Text('Night')),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (v) => notifier.change((s) => s.copyWith(themeMode: v.first)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'About',
              child: Text(
                'JaapMala 1.0.0\nYour jaap and thoughts are stored only on this device.',
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
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final g in AppSettings.goalPresets)
                  ActionChip(label: Text('$g'), onPressed: () => Navigator.pop(context, g)),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Custom goal'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text) ?? 0;
              Navigator.pop(context, value > 0 ? value : null);
            },
            child: const Text('Save'),
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
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add your naam'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Name', hintText: 'e.g. Sita Ram'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: script,
                decoration: const InputDecoration(labelText: 'Shown on mala (optional)', hintText: 'e.g. सीता राम'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: greeting,
                decoration: const InputDecoration(labelText: 'Greeting (optional)', hintText: 'e.g. Jai Siya Ram'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Add')),
        ],
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty) {
      await ref.read(naamsProvider.notifier).add(name: name.text, script: script.text, greeting: greeting.text);
    }
    name.dispose();
    script.dispose();
    greeting.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final naams = ref.watch(naamsProvider);
    final selectedId = ref.watch(settingsProvider.select((s) => s.selectedNaamId));

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
            title: Text(naam.name),
            subtitle: Text(naam.greeting),
            onTap: () => ref.read(settingsProvider.notifier).change((s) => s.copyWith(selectedNaamId: naam.id)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (naam.id == selectedId) const Icon(Icons.check_circle_rounded, color: AppColors.kesari),
                if (naam.isCustom && naams.length > 1)
                  IconButton(
                    tooltip: 'Remove',
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
            label: const Text('Add your own naam'),
          ),
        ),
      ],
    );
  }
}
