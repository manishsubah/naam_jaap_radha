import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/theme/app_colors.dart';

String formatDuration(Duration d) {
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return d.inHours > 0 ? '${d.inHours}:$m:$s' : '$m:$s';
}

class AudioPlayerTile extends StatefulWidget {
  const AudioPlayerTile({super.key, required this.path, this.onDelete});

  final String path;
  final VoidCallback? onDelete;

  @override
  State<AudioPlayerTile> createState() => _AudioPlayerTileState();
}

class _AudioPlayerTileState extends State<AudioPlayerTile> {
  AudioPlayer? _player;
  bool _missing = false;

  @override
  void initState() {
    super.initState();
    _missing = !File(widget.path).existsSync();
  }

  @override
  void didUpdateWidget(AudioPlayerTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _player?.dispose();
      _player = null;
      _missing = !File(widget.path).existsSync();
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    var player = _player;
    if (player == null) {
      player = AudioPlayer();
      try {
        await player.setFilePath(widget.path);
      } catch (_) {
        await player.dispose();
        setState(() => _missing = true);
        return;
      }
      setState(() => _player = player);
    }
    if (player.playing) {
      await player.pause();
    } else {
      if (player.processingState == ProcessingState.completed) await player.seek(Duration.zero);
      player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final player = _player;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.saffron.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (_missing)
            const Padding(padding: EdgeInsets.all(12), child: Icon(Icons.mic_off_rounded))
          else
            StreamBuilder<PlayerState>(
              stream: player?.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                final done = snapshot.data?.processingState == ProcessingState.completed;
                return IconButton(
                  onPressed: _toggle,
                  icon: Icon(playing && !done ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded),
                  iconSize: 36,
                  color: theme.colorScheme.primary,
                );
              },
            ),
          Expanded(
            child: _missing
                ? Text('Voice note unavailable', style: theme.textTheme.bodySmall)
                : StreamBuilder<Duration>(
                    stream: player?.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final total = player?.duration ?? Duration.zero;
                      final progress = total.inMilliseconds == 0
                          ? 0.0
                          : (position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 5,
                              backgroundColor: AppColors.gold.withValues(alpha: 0.2),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            player == null
                                ? 'Voice note'
                                : '${formatDuration(position)} / ${formatDuration(total)}',
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      );
                    },
                  ),
          ),
          if (widget.onDelete != null)
            IconButton(
              tooltip: 'Remove voice note',
              onPressed: widget.onDelete,
              icon: const Icon(Icons.close_rounded),
            ),
        ],
      ),
    );
  }
}
