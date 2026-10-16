import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:naam_jaap/core/theme/app_colors.dart';
import 'package:naam_jaap/core/widgets/devotional_background.dart';
import 'package:naam_jaap/data/models/thought.dart';
import 'package:naam_jaap/data/providers/providers.dart';
import 'package:naam_jaap/core/services/audio_recorder_service.dart';
import 'package:naam_jaap/core/services/speech_service.dart';
import 'package:naam_jaap/features/thoughts/presentation/widgets/audio_player_tile.dart';

class ThoughtEditorScreen extends ConsumerStatefulWidget {
  const ThoughtEditorScreen({super.key, this.thoughtId});

  final String? thoughtId;

  @override
  ConsumerState<ThoughtEditorScreen> createState() => _ThoughtEditorScreenState();
}

class _ThoughtEditorScreenState extends ConsumerState<ThoughtEditorScreen> {
  final _text = TextEditingController();
  final _speech = SpeechService();
  final _recorder = AudioRecorderService();
  final _recordWatch = Stopwatch();

  Thought? _existing;
  ThoughtMood? _mood;
  String? _audioPath;
  int? _audioDurationMs;
  bool _listening = false;
  bool _recording = false;
  bool _saved = false;
  String _textBeforeListening = '';
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    final id = widget.thoughtId;
    if (id != null) {
      _existing = ref.read(thoughtsProvider).where((t) => t.id == id).firstOrNull;
      _text.text = _existing?.text ?? '';
      _mood = _existing?.mood;
      _audioPath = _existing?.audioPath;
      _audioDurationMs = _existing?.audioDurationMs;
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    if (_listening) _speech.stop();
    if (_recording) _recorder.cancel();
    if (!_saved) _discardUnsavedAudio();
    _recorder.dispose();
    _text.dispose();
    super.dispose();
  }

  void _discardUnsavedAudio() {
    if (_audioPath != null && _audioPath != _existing?.audioPath) {
      ThoughtsNotifier.deleteAudioFile(_audioPath);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, content: Text(message)));
  }

  Future<void> _toggleSpeech() async {
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    if (_recording) await _stopRecording();

    _textBeforeListening = _text.text.trimRight();
    final locale = ref.read(settingsProvider).speechLocale;
    final started = await _speech.listen(
      localeId: locale,
      onResult: (words, _) {
        final joiner = _textBeforeListening.isEmpty ? '' : ' ';
        _text.text = '$_textBeforeListening$joiner$words';
        _text.selection = TextSelection.collapsed(offset: _text.text.length);
      },
      onDone: () {
        if (mounted) setState(() => _listening = false);
      },
    );
    if (!mounted) return;
    if (!started) {
      _toast('Speech recognition is not available. Please allow microphone and speech access.');
      return;
    }
    setState(() => _listening = true);
  }

  Future<void> _toggleRecording() async {
    if (_recording) {
      await _stopRecording();
      return;
    }
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
    }

    final started = await _recorder.start();
    if (!mounted) return;
    if (!started) {
      _toast('Microphone permission is needed to record a voice note.');
      return;
    }
    _recordWatch
      ..reset()
      ..start();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
    setState(() => _recording = true);
  }

  Future<void> _stopRecording() async {
    _ticker?.cancel();
    _recordWatch.stop();
    final path = await _recorder.stop();
    if (!mounted) return;
    setState(() {
      _recording = false;
      if (path != null) {
        _discardUnsavedAudio();
        _audioPath = path;
        _audioDurationMs = _recordWatch.elapsedMilliseconds;
      }
    });
  }

  void _removeAudio() {
    setState(() {
      _discardUnsavedAudio();
      _audioPath = null;
      _audioDurationMs = null;
    });
  }

  Future<void> _save() async {
    if (_listening) await _speech.stop();
    if (_recording) await _stopRecording();

    final text = _text.text.trim();
    if (text.isEmpty && _audioPath == null) {
      _toast('Write, speak, or record something first.');
      return;
    }

    final notifier = ref.read(thoughtsProvider.notifier);
    final now = DateTime.now();
    await notifier.save(Thought(
      id: _existing?.id ?? notifier.newId(),
      text: text,
      mood: _mood,
      audioPath: _audioPath,
      audioDurationMs: _audioDurationMs,
      createdAt: _existing?.createdAt ?? now,
      updatedAt: now,
    ));
    _saved = true;
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this thought?'),
        content: const Text('The text and any voice note will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true || _existing == null) return;
    _discardUnsavedAudio();
    await ref.read(thoughtsProvider.notifier).remove(_existing!.id);
    _saved = true;
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeLabel = {'hi_IN': 'Hindi', 'en_IN': 'English'}[ref.watch(settingsProvider).speechLocale];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(_existing == null ? 'New thought' : 'Edit thought'),
        actions: [
          if (_existing != null)
            IconButton(tooltip: 'Delete', onPressed: _delete, icon: const Icon(Icons.delete_outline_rounded)),
          IconButton(tooltip: 'Save', onPressed: _save, icon: const Icon(Icons.check_rounded)),
        ],
      ),
      body: DevotionalBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(
                DateFormat('EEEE, d MMMM yyyy').format(_existing?.createdAt ?? DateTime.now()),
                style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.tertiary),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final mood in ThoughtMood.values)
                    ChoiceChip(
                      label: Text(mood.label),
                      selected: _mood == mood,
                      onSelected: (on) => setState(() => _mood = on ? mood : null),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _text,
                minLines: 8,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'What did you feel during your jaap today?',
                ),
              ),
              if (_listening) ...[
                const SizedBox(height: 12),
                _LiveBanner(
                  icon: Icons.graphic_eq_rounded,
                  label: 'Listening in $localeLabel... speak now',
                ),
              ],
              if (_recording) ...[
                const SizedBox(height: 12),
                _LiveBanner(
                  icon: Icons.fiber_manual_record_rounded,
                  color: Colors.red,
                  label: 'Recording voice note  ${formatDuration(_recordWatch.elapsed)}',
                ),
              ],
              if (_audioPath != null && !_recording) ...[
                const SizedBox(height: 12),
                AudioPlayerTile(path: _audioPath!, onDelete: _removeAudio),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _VoiceButton(
                      active: _listening,
                      icon: _listening ? Icons.stop_rounded : Icons.keyboard_voice_rounded,
                      label: _listening ? 'Stop' : 'Speak to write',
                      onPressed: _toggleSpeech,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _VoiceButton(
                      active: _recording,
                      icon: _recording ? Icons.stop_rounded : Icons.mic_rounded,
                      label: _recording ? 'Stop recording' : 'Record voice',
                      onPressed: _toggleRecording,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Speak to write turns your words into text. Record voice saves your own voice as a note.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.favorite_rounded),
                label: const Text('Save thought'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoiceButton extends StatelessWidget {
  const _VoiceButton({required this.active, required this.icon, required this.label, required this.onPressed});

  final bool active;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: active ? AppColors.saffron.withValues(alpha: 0.2) : null,
        side: BorderSide(color: active ? AppColors.kesari : AppColors.gold.withValues(alpha: 0.6)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
    if (!active) return button;
    return button
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(begin: 1, end: 1.04, duration: 700.ms, curve: Curves.easeInOut);
  }
}

class _LiveBanner extends StatelessWidget {
  const _LiveBanner({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.saffron.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color ?? AppColors.kesari)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fade(begin: 0.4, end: 1, duration: 600.ms),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
