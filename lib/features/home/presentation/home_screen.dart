import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:naam_jaap/app/router.dart';
import 'package:naam_jaap/core/theme/app_colors.dart';
import 'package:naam_jaap/core/theme/app_theme.dart';
import 'package:naam_jaap/core/widgets/devotional_background.dart';
import 'package:naam_jaap/core/widgets/diya_glow.dart';
import 'package:naam_jaap/core/widgets/goal_ring.dart';
import 'package:naam_jaap/core/widgets/section_card.dart';
import 'package:naam_jaap/data/providers/providers.dart';
import 'package:naam_jaap/l10n/l10n.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final naam = ref.watch(selectedNaamProvider);
    final settings = ref.watch(settingsProvider);
    final today = ref.watch(todayTotalProvider);
    final streak = ref.watch(streakProvider);
    final lifetime = ref.watch(lifetimeTotalProvider);
    final thoughts = ref.watch(thoughtsProvider);
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    final accent = theme.brightness == Brightness.dark ? AppColors.lightGold : AppColors.maroon;
    final numbers = l10n.numbers;
    final vachans = l10n.vachans;

    final sections = <Widget>[
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.naamGreeting(naam),
                  style: AppFonts.heading(theme.textTheme.headlineMedium).copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(l10n.formatDate('EEEE, d MMMM', now), style: theme.textTheme.bodyMedium),
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
                  Text(l10n.homeGoalProgress(numbers.format(settings.dailyGoal)), style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.go(AppRoutes.jaap),
                icon: const Icon(Icons.blur_circular_rounded),
                label: Text(l10n.homeStartJaap(l10n.naamName(naam))),
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
              value: numbers.format(streak),
              label: l10n.homeStreak(streak),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatTile(
              icon: Icons.blur_circular_rounded,
              color: AppColors.gold,
              value: numbers.format(today ~/ settings.malaSize),
              label: l10n.homeMalasToday,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatTile(
              icon: Icons.all_inclusive_rounded,
              color: AppColors.maroon,
              value: l10n.compactNumbers.format(lifetime),
              label: l10n.homeLifetime,
            ),
          ),
        ],
      ),
      SectionCard(
        title: l10n.homeVachanTitle,
        child: Text(
          vachans[dayOfYear % vachans.length],
          style: AppFonts.heading(theme.textTheme.titleMedium).copyWith(height: 1.5),
        ),
      ),
      SectionCard(
        title: thoughts.isEmpty ? l10n.homeCaptureThought : l10n.homeLatestThought,
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => thoughts.isEmpty
            ? context.push(AppRoutes.newThought)
            : context.go(AppRoutes.thoughts),
        child: Text(
          thoughts.isEmpty
              ? l10n.homeCaptureHint
              : (thoughts.first.text.isNotEmpty ? thoughts.first.text : l10n.voiceNote),
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
          // Scales down rather than wrapping, so long values like "4.52 लाख"
          // keep the three tiles the same height.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, maxLines: 1, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          ),
          Text(label, style: theme.textTheme.labelSmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
