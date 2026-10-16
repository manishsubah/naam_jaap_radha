import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'data/repositories/local/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final overrides = await LocalStorage.open();
  runApp(ProviderScope(overrides: overrides, child: const JaapMalaApp()));
}
