import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/devotional_background.dart';
import '../../core/widgets/diya_glow.dart';
import '../../core/widgets/goal_ring.dart';
import '../../core/widgets/section_card.dart';
import '../../data/providers.dart';

const _vachans = [
  'Naam is the boat that carries us across the ocean of life.',
  'Chant with love, and every bead becomes a prayer.',
  'Where there is remembrance, there is peace.',
  'One name, repeated with faith, can quiet a thousand thoughts.',
  'Begin with one mala. Devotion grows with every bead.',
  'The heart that remembers is never alone.',
  'Kalijug keval naam adhara: in this age, the Name is our support.',
  'Breathe in, breathe out, and let the Name fill the space between.',
];

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final naam = ref.watch(selectedNaamProvider);
    final settings = ref.watch(settingsProvider);
    final today = ref.watch(todayTotalProvider);
    final streak = ref.watch(streakProvider);
    final lifetime = ref.watch(lifetimeTotalProvider);
    final thoughts = ref.watch(thoughtsProvider);
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    final accent = theme.brightness == Brightness.dark ? AppColors.lightGold : AppColors.maroon;
    final numbers = NumberFormat.decimalPattern('en_IN');

    final sections = <Widget>[
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  naam.greeting,
                  style: AppFonts.heading(theme.textTheme.headlineMedium).copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(DateFormat('EEEE, d MMMM').format(now), style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const DiyaGlow(size: 56),
        ],
      ),
      SectionCard(
        child: Column(
          children: [
            GoalRing(
              progress: settings.dailyGoal == 0 ? 0 : today / settings.dailyGoal,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    numbers.format(today),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text('of ${numbers.format(settings.dailyGoal)} today', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.go(AppRoutes.jaap),
                icon: const Icon(Icons.blur_circular_rounded),
                label: Text('Start ${naam.name} Jaap'),
              ),
            ),
          ],
        ),
      ),
      Row(
        children: [
          Expanded(
            child: _StatTile(
              icon: Icons.local_fire_department_rounded,
              color: AppColors.kesari,
              value: '$streak',
              label: streak == 1 ? 'day streak' : 'days streak',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatTile(
              icon: Icons.blur_circular_rounded,
              color: AppColors.gold,
              value: '${today ~/ settings.malaSize}',
              label: 'malas today',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatTile(
              icon: Icons.all_inclusive_rounded,
              color: AppColors.maroon,
              value: NumberFormat.compact(locale: 'en_IN').format(lifetime),
              label: 'lifetime',
            ),
          ),
        ],
      ),
      SectionCard(
        title: 'Aaj ka vachan',
        child: Text(
          _vachans[dayOfYear % _vachans.length],
          style: AppFonts.heading(theme.textTheme.titleMedium).copyWith(height: 1.5),
        ),
      ),
      SectionCard(
        title: thoughts.isEmpty ? 'Capture a thought' : 'Latest thought',
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => thoughts.isEmpty
            ? context.push(AppRoutes.newThought)
            : context.go(AppRoutes.thoughts),
        child: Text(
          thoughts.isEmpty
              ? 'Write or speak what is in your heart after your jaap.'
              : (thoughts.first.text.isNotEmpty ? thoughts.first.text : 'Voice note'),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    ];

    return DevotionalBackground(
      child: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          itemCount: sections.length,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (_, i) => sections[i]
              .animate()
              .fadeIn(delay: (60 * i).ms, duration: 400.ms)
              .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.color, required this.value, required this.label});

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SectionCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 6),
          Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          Text(label, style: theme.textTheme.labelSmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
