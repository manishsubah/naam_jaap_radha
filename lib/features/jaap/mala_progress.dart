class MalaProgress {
  const MalaProgress({required this.count, required this.malaSize})
      : assert(malaSize > 0);

  final int count;
  final int malaSize;

  int get completedMalas => count ~/ malaSize;

  int get beadsInCurrentMala => count % malaSize;

  bool get isMalaBoundary => count > 0 && count % malaSize == 0;

  MalaProgress advance() => MalaProgress(count: count + 1, malaSize: malaSize);

  MalaProgress undo() => MalaProgress(count: count > 0 ? count - 1 : 0, malaSize: malaSize);
}
