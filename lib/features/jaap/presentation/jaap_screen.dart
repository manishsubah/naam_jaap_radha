import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:naam_jaap/core/theme/app_colors.dart';
import 'package:naam_jaap/core/theme/app_theme.dart';
import 'package:naam_jaap/core/widgets/devotional_background.dart';
import 'package:naam_jaap/data/models/naam.dart';
import 'package:naam_jaap/data/providers/providers.dart';
import 'package:naam_jaap/core/services/haptic_sound_service.dart';
import 'package:naam_jaap/features/jaap/presentation/widgets/mala_painter.dart';
import 'package:naam_jaap/features/jaap/domain/mala_progress.dart';
import 'package:naam_jaap/features/jaap/presentation/widgets/manual_entry_sheet.dart';
import 'package:naam_jaap/features/jaap/presentation/widgets/petal_burst.dart';

class JaapScreen extends ConsumerStatefulWidget {
  const JaapScreen({super.key});

  @override
  ConsumerState<JaapScreen> createState() => _JaapScreenState();
}

class _JaapScreenState extends ConsumerState<JaapScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
    value: 1,
  );
  int _burstTrigger = 0;

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _chant() {
    final settings = ref.read(settingsProvider);
    final naam = ref.read(selectedNaamProvider);
    final progress = MalaProgress(
      count: ref.read(todayCountForNaamProvider(naam.id)),
      malaSize: settings.malaSize,
    ).advance();

    ref.read(jaapEntriesProvider.notifier).addCount(naam.id, 1);
    _pulse.forward(from: 0);

    final feedback = ref.read(hapticSoundServiceProvider);
    if (progress.isMalaBoundary) {
      feedback.malaComplete(vibrate: settings.vibrationEnabled, sound: settings.soundEnabled);
      setState(() => _burstTrigger++);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Mala ${progress.completedMalas} complete. ${naam.greeting}!'),
        ));
    } else {
      feedback.bead(vibrate: settings.vibrationEnabled);
    }
  }

  void _undo() {
    final naam = ref.read(selectedNaamProvider);
    if (ref.read(todayCountForNaamProvider(naam.id)) == 0) return;
    ref.read(jaapEntriesProvider.notifier).addCount(naam.id, -1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final naam = ref.watch(selectedNaamProvider);
    final malaSize = ref.watch(settingsProvider.select((s) => s.malaSize));
    final count = ref.watch(todayCountForNaamProvider(naam.id));
    final progress = MalaProgress(count: count, malaSize: malaSize);
    final isDark = theme.brightness == Brightness.dark;

    return DevotionalBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
              child: Row(
                children: [
                  Expanded(child: Text('Naam Jaap', style: theme.appBarTheme.titleTextStyle)),
                  IconButton(
                    tooltip: 'Add count manually',
                    icon: const Icon(Icons.edit_note_rounded),
                    onPressed: () => showManualEntrySheet(context),
                  ),
                ],
              ),
            ),
            _NaamSelector(selected: naam),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _chant,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CustomPaint(
                          painter: MalaPainter(
                            total: malaSize,
                            filled: progress.beadsInCurrentMala,
                            pulse: _pulse,
                            threadColor: AppColors.gold.withValues(alpha: isDark ? 0.5 : 0.7),
                          ),
                          child: Center(child: _MalaCenter(naam: naam, progress: progress)),
                        ),
                      ),
                    ),
                    Positioned.fill(child: PetalBurst(trigger: _burstTrigger)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    tooltip: 'Undo last bead',
                    onPressed: count == 0 ? null : _undo,
                    icon: const Icon(Icons.undo_rounded),
                  ),
                  Expanded(
                    child: Text(
                      'Tap anywhere on the mala to chant',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: 'Add count manually',
                    onPressed: () => showManualEntrySheet(context),
                    icon: const Icon(Icons.add_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MalaCenter extends StatelessWidget {
  const _MalaCenter({required this.naam, required this.progress});

  final Naam naam;
  final MalaProgress progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.brightness == Brightness.dark ? AppColors.lightGold : AppColors.maroon;

    return FractionallySizedBox(
      widthFactor: 0.62,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Text(
              naam.script,
              style: AppFonts.heading(theme.textTheme.displaySmall).copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${progress.count}',
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          )
              .animate(key: ValueKey(progress.count))
              .scaleXY(begin: 1.18, end: 1, duration: 200.ms, curve: Curves.easeOut),
          Text(
            'today',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Mala ${progress.completedMalas}  •  ${progress.beadsInCurrentMala}/${progress.malaSize}',
              style: theme.textTheme.labelLarge?.copyWith(color: accent, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _NaamSelector extends ConsumerWidget {
  const _NaamSelector({required this.selected});

  final Naam selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final naams = ref.watch(naamsProvider);
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: naams.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final naam = naams[i];
          return ChoiceChip(
            label: Text(naam.name),
            selected: naam.id == selected.id,
            onSelected: (_) => ref
                .read(settingsProvider.notifier)
                .change((s) => s.copyWith(selectedNaamId: naam.id)),
          );
        },
      ),
    );
  }
}
