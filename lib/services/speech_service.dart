import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _ready = false;
  void Function()? _onDone;

  bool get isListening => _speech.isListening;

  Future<bool> _ensureReady() async {
    if (_ready) return true;
    _ready = await _speech.initialize(
      onStatus: (status) {
        if (status == SpeechToText.doneStatus || status == SpeechToText.notListeningStatus) {
          _onDone?.call();
        }
      },
      onError: (_) => _onDone?.call(),
    );
    return _ready;
  }

  Future<bool> listen({
    required String localeId,
    required void Function(String words, bool isFinal) onResult,
    required void Function() onDone,
  }) async {
    if (!await _ensureReady()) return false;
    _onDone = onDone;
    await _speech.listen(
      onResult: (SpeechRecognitionResult r) => onResult(r.recognizedWords, r.finalResult),
      listenOptions: SpeechListenOptions(
        localeId: localeId,
        partialResults: true,
        listenMode: ListenMode.dictation,
        cancelOnError: true,
        pauseFor: const Duration(seconds: 5),
        listenFor: const Duration(minutes: 2),
      ),
    );
    return true;
  }

  Future<void> stop() async {
    _onDone = null;
    await _speech.stop();
  }
}
