import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class HapticSoundService {
  AudioPlayer? _bell;

  Future<void> bead({required bool vibrate}) async {
    if (vibrate) await HapticFeedback.lightImpact();
  }

  Future<void> malaComplete({required bool vibrate, required bool sound}) async {
    if (vibrate) await HapticFeedback.heavyImpact();
    if (sound) await _ringBell();
  }

  Future<void> _ringBell() async {
    try {
      final player = _bell ??= AudioPlayer();
      if (player.audioSource == null) {
        await player.setAsset('assets/sounds/bell.wav');
      }
      await player.seek(Duration.zero);
      unawaited(player.play());
    } catch (_) {}
  }

  void dispose() => _bell?.dispose();
}

final hapticSoundServiceProvider = Provider<HapticSoundService>((ref) {
  final service = HapticSoundService();
  ref.onDispose(service.dispose);
  return service;
});
