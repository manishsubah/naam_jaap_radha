import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:naam_jaap/data/models/thought.dart';
import 'package:naam_jaap/data/providers/repository_providers.dart';

const _uuid = Uuid();

class ThoughtsNotifier extends Notifier<List<Thought>> {
  @override
  List<Thought> build() => _sorted(ref.read(thoughtRepositoryProvider).getAll());

  static List<Thought> _sorted(List<Thought> list) =>
      [...list]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  String newId() => _uuid.v4();

  Future<void> save(Thought thought) async {
    final previous = state.where((t) => t.id == thought.id).firstOrNull;
    if (previous?.audioPath != null && previous!.audioPath != thought.audioPath) {
      await deleteAudioFile(previous.audioPath);
    }
    state = _sorted([...state.where((t) => t.id != thought.id), thought]);
    await ref.read(thoughtRepositoryProvider).save(thought);
  }

  Future<void> remove(String id) async {
    final thought = state.where((t) => t.id == id).firstOrNull;
    state = state.where((t) => t.id != id).toList();
    await ref.read(thoughtRepositoryProvider).delete(id);
    await deleteAudioFile(thought?.audioPath);
  }

  static Future<void> deleteAudioFile(String? path) async {
    if (path == null) return;
    final file = File(path);
    if (await file.exists()) await file.delete();
  }
}

final thoughtsProvider = NotifierProvider<ThoughtsNotifier, List<Thought>>(ThoughtsNotifier.new);
