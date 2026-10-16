import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorderService {
  AudioRecorder? _recorder;

  Future<bool> start() async {
    final recorder = _recorder ??= AudioRecorder();
    if (!await recorder.hasPermission()) return false;

    final docs = await getApplicationDocumentsDirectory();
    final folder = Directory('${docs.path}/voice_notes');
    await folder.create(recursive: true);
    final path = '${folder.path}/thought_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);
    return true;
  }

  Future<String?> stop() async => _recorder?.stop();

  Future<void> cancel() async => _recorder?.cancel();

  void dispose() => _recorder?.dispose();
}
