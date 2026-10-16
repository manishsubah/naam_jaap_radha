import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:naam_jaap/features/history/presentation/history_screen.dart';
import 'package:naam_jaap/features/home/presentation/home_screen.dart';
import 'package:naam_jaap/features/jaap/presentation/jaap_screen.dart';
import 'package:naam_jaap/features/settings/presentation/settings_screen.dart';
import 'package:naam_jaap/features/thoughts/presentation/thought_editor_screen.dart';
import 'package:naam_jaap/features/thoughts/presentation/thoughts_screen.dart';
import 'package:naam_jaap/app/app_shell.dart';

abstract final class AppRoutes {
  static const home = '/home';
  static const jaap = '/jaap';
  static const history = '/history';
  static const thoughts = '/thoughts';
  static const settings = '/settings';
  static const newThought = '/thought/new';
  static String thought(String id) => '/thought/$id';
}

final routerProvider = Provider<GoRouter>((ref) {
  final rootKey = GlobalKey<NavigatorState>();

  final router = GoRouter(
    navigatorKey: rootKey,
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.jaap, builder: (_, _) => const JaapScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.history, builder: (_, _) => const HistoryScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.thoughts, builder: (_, _) => const ThoughtsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.settings, builder: (_, _) => const SettingsScreen()),
          ]),
        ],
      ),
      GoRoute(
        path: '/thought/:id',
        parentNavigatorKey: rootKey,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return ThoughtEditorScreen(thoughtId: id == 'new' ? null : id);
        },
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
