import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:naam_jaap/core/widgets/section_card.dart';
import 'package:naam_jaap/data/sync/sync_controller.dart';

/// Sign in with Google to keep jaap records in the user's own Google account.
class GoogleBackupCard extends ConsumerWidget {
  const GoogleBackupCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sync = ref.watch(syncControllerProvider);
    final controller = ref.read(syncControllerProvider.notifier);
    final busy = sync.status == SyncStatus.connecting || sync.status == SyncStatus.syncing;

    final Widget body = switch (sync.status) {
      SyncStatus.unavailable => Text(
          'Google backup is not set up in this build of the app.',
          style: theme.textTheme.bodyMedium,
        ),
      SyncStatus.signedOut || SyncStatus.connecting when !sync.isSignedIn => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Keep your jaap records safe in your Google account. They sync across '
              'your devices and come back if you reinstall. Only JaapMala can see them.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: busy ? null : controller.signIn,
              icon: busy
                  ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.login_rounded),
              label: const Text('Sign in with Google'),
            ),
          ],
        ),
      _ => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.account_circle_rounded),
              title: Text(sync.email ?? 'Google account'),
              subtitle: Text(_statusText(sync)),
            ),
            if (sync.status == SyncStatus.error && sync.message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(sync.message!, style: TextStyle(color: theme.colorScheme.error)),
              ),
            Row(
              children: [
                Expanded(
                  child: sync.status == SyncStatus.needsReconnect
                      ? FilledButton(onPressed: controller.signIn, child: const Text('Reconnect'))
                      : FilledButton.tonalIcon(
                          onPressed: busy ? null : () => controller.syncNow(interactive: true),
                          icon: busy
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.sync_rounded),
                          label: const Text('Sync now'),
                        ),
                ),
                const SizedBox(width: 12),
                TextButton(onPressed: busy ? null : controller.signOut, child: const Text('Sign out')),
              ],
            ),
          ],
        ),
    };

    return SectionCard(title: 'Google backup', child: body);
  }

  static String _statusText(SyncState sync) => switch (sync.status) {
        SyncStatus.syncing || SyncStatus.connecting => 'Syncing…',
        SyncStatus.needsReconnect => 'Google needs you to sign in again',
        SyncStatus.error => 'Last sync failed',
        _ when sync.lastSyncedAt != null =>
          'Synced ${DateFormat('d MMM, h:mm a').format(sync.lastSyncedAt!)}',
        _ => 'Signed in',
      };
}
