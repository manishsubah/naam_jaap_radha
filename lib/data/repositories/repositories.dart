import 'package:naam_jaap/data/models/app_settings.dart';
import 'package:naam_jaap/data/models/jaap_entry.dart';
import 'package:naam_jaap/data/models/naam.dart';
import 'package:naam_jaap/data/models/thought.dart';

abstract interface class NaamRepository {
  List<Naam> getAll();
  Future<void> save(Naam naam);
  Future<void> delete(String id);
}

abstract interface class JaapRepository {
  List<JaapEntry> getAll();
  Future<void> save(JaapEntry entry);
  Future<void> delete(String id);
}

abstract interface class ThoughtRepository {
  List<Thought> getAll();
  Future<void> save(Thought thought);
  Future<void> delete(String id);
}

abstract interface class SettingsRepository {
  AppSettings load();
  Future<void> save(AppSettings settings);
}
