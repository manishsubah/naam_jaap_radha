import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:naam_jaap/core/theme/app_theme.dart';
import 'package:naam_jaap/data/providers/providers.dart';
import 'package:naam_jaap/data/sync/sync_controller.dart';
import 'package:naam_jaap/app/router.dart';

class JaapMalaApp extends ConsumerWidget {
  const JaapMalaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));
    // Keeps Google sync running for the life of the app.
    ref.listen(syncControllerProvider, (_, _) {});

    return MaterialApp.router(
      title: 'JaapMala',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
