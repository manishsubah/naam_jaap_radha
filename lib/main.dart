import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:naam_jaap/app/app.dart';
import 'package:naam_jaap/data/local/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final overrides = await LocalStorage.open();
  runApp(ProviderScope(overrides: overrides, child: const JaapMalaApp()));
}
