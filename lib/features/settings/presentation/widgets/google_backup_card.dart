import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:naam_jaap/core/widgets/section_card.dart';
import 'package:naam_jaap/data/sync/sync_controller.dart';
import 'package:naam_jaap/l10n/l10n.dart';

/// Sign in with Google to keep jaap records in the user's own Google account.
class GoogleBackupCard extends ConsumerWidget {
  const GoogleBackupCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final sync = ref.watch(syncControllerProvider);
    final controller = ref.read(syncControllerProvider.notifier);
    final busy = sync.status == SyncStatus.connecting || sync.status == SyncStatus.syncing;

    final Widget body = switch (sync.status) {
      SyncStatus.unavailable => Text(
          l10n.backupUnavailable,
          style: theme.textTheme.bodyMedium,
        ),
      SyncStatus.signedOut || SyncStatus.connecting when !sync.isSignedIn => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.backupIntro,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: busy ? null : controller.signIn,
              icon: busy
                  ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.login_rounded),
              label: Text(l10n.backupSignIn),
            ),
          ],
        ),
      _ => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.account_circle_rounded),
              title: Text(sync.email ?? l10n.backupAccount),
              subtitle: Text(_statusText(l10n, sync)),
            ),
            if (sync.status == SyncStatus.error && sync.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(_errorText(l10n, sync.error!), style: TextStyle(color: theme.colorScheme.error)),
              ),
            Row(
              children: [
                Expanded(
                  child: sync.status == SyncStatus.needsReconnect
                      ? FilledButton(onPressed: controller.signIn, child: Text(l10n.backupReconnect))
                      : FilledButton.tonalIcon(
                          onPressed: busy ? null : () => controller.syncNow(interactive: true),
                          icon: busy
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.sync_rounded),
                          label: Text(l10n.backupSyncNow),
                        ),
                ),
                const SizedBox(width: 12),
                TextButton(onPressed: busy ? null : controller.signOut, child: Text(l10n.backupSignOut)),
              ],
            ),
          ],
        ),
    };

    return SectionCard(title: l10n.backupTitle, child: body);
  }

  static String _statusText(AppLocalizations l10n, SyncState sync) => switch (sync.status) {
        SyncStatus.syncing || SyncStatus.connecting => l10n.syncBadgeSyncing,
        SyncStatus.needsReconnect => l10n.backupStatusReconnect,
        SyncStatus.error => l10n.backupStatusFailed,
        _ when sync.lastSyncedAt != null =>
          l10n.backupStatusSynced(l10n.formatDate('d MMM, h:mm a', sync.lastSyncedAt!)),
        _ => l10n.backupStatusSignedIn,
      };

  static String _errorText(AppLocalizations l10n, SyncError error) => switch (error) {
        SyncError.signIn => l10n.syncErrorSignIn,
        SyncError.driveUnreachable => l10n.syncErrorDrive,
        SyncError.unreadableBackup => l10n.syncErrorUnreadable,
        SyncError.unknown => l10n.syncErrorGeneric,
      };
}
