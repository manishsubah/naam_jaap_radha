import 'package:flutter_riverpod/misc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:naam_jaap/data/models/naam.dart';
import 'package:naam_jaap/data/providers/repository_providers.dart';
import 'package:naam_jaap/data/local/hive_repositories.dart';

abstract final class LocalStorage {
  static Future<List<Override>> open() async {
    await Hive.initFlutter('jaapmala');
    final naams = await Hive.openBox<Map>('naams');
    final jaap = await Hive.openBox<Map>('jaap_entries');
    final thoughts = await Hive.openBox<Map>('thoughts');
    final settings = await Hive.openBox<Map>('settings');

    if (naams.isEmpty) {
      await naams.putAll({for (final n in Naam.defaults) n.id: n.toMap()});
    }

    return [
      naamRepositoryProvider.overrideWithValue(HiveNaamRepository(naams)),
      jaapRepositoryProvider.overrideWithValue(HiveJaapRepository(jaap)),
      thoughtRepositoryProvider.overrideWithValue(HiveThoughtRepository(thoughts)),
      settingsRepositoryProvider.overrideWithValue(HiveSettingsRepository(settings)),
    ];
  }
}
