import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:naam_jaap/app/router.dart';
import 'package:naam_jaap/core/theme/app_colors.dart';
import 'package:naam_jaap/core/widgets/devotional_background.dart';
import 'package:naam_jaap/core/widgets/diya_glow.dart';
import 'package:naam_jaap/core/widgets/section_card.dart';
import 'package:naam_jaap/data/models/thought.dart';
import 'package:naam_jaap/data/providers/providers.dart';
import 'package:naam_jaap/features/thoughts/presentation/widgets/audio_player_tile.dart';
import 'package:naam_jaap/l10n/l10n.dart';

class ThoughtsScreen extends ConsumerWidget {
  const ThoughtsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final thoughts = ref.watch(thoughtsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.newThought),
        icon: const Icon(Icons.edit_rounded),
        label: Text(context.l10n.thoughtNew),
      ),
      body: DevotionalBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Text(context.l10n.thoughtsTitle, style: theme.appBarTheme.titleTextStyle),
              ),
              Expanded(
                child: thoughts.isEmpty
                    ? const _EmptyThoughts()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                        itemCount: thoughts.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, i) => _ThoughtCard(thought: thoughts[i])
                            .animate()
                            .fadeIn(delay: (40 * i).ms)
                            .slideX(begin: 0.05, end: 0),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThoughtCard extends StatelessWidget {
  const _ThoughtCard({required this.thought});

  final Thought thought;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SectionCard(
      padding: const EdgeInsets.all(16),
      onTap: () => context.push(AppRoutes.thought(thought.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.formatDate('d MMM yyyy, h:mm a', thought.createdAt),
                style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.tertiary),
              ),
              const Spacer(),
              if (thought.mood != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(l10n.moodLabel(thought.mood!), style: theme.textTheme.labelSmall),
                ),
            ],
          ),
          if (thought.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(thought.text, maxLines: 4, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
          ],
          if (thought.audioPath != null) ...[
            const SizedBox(height: 10),
            AudioPlayerTile(path: thought.audioPath!),
          ],
        ],
      ),
    );
  }
}

class _EmptyThoughts extends StatelessWidget {
  const _EmptyThoughts();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DiyaGlow(size: 88),
            const SizedBox(height: 16),
            Text(l10n.thoughtsEmptyTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              l10n.thoughtsEmptyBody(l10n.thoughtNew),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
