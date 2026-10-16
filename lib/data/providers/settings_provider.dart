import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:naam_jaap/data/models/app_settings.dart';
import 'package:naam_jaap/data/providers/repository_providers.dart';

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(settingsRepositoryProvider).load();

  Future<void> change(AppSettings Function(AppSettings current) update) async {
    state = update(state);
    await ref.read(settingsRepositoryProvider).save(state);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
