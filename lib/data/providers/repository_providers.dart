import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:naam_jaap/data/repositories/repositories.dart';

Never _notConfigured(String name) =>
    throw UnimplementedError('$name must be overridden in ProviderScope');

final naamRepositoryProvider = Provider<NaamRepository>((_) => _notConfigured('naamRepositoryProvider'));
final jaapRepositoryProvider = Provider<JaapRepository>((_) => _notConfigured('jaapRepositoryProvider'));
final thoughtRepositoryProvider =
    Provider<ThoughtRepository>((_) => _notConfigured('thoughtRepositoryProvider'));
final settingsRepositoryProvider =
    Provider<SettingsRepository>((_) => _notConfigured('settingsRepositoryProvider'));
