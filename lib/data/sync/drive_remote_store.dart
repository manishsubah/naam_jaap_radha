import 'dart:convert';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

import 'package:naam_jaap/data/sync/remote_store.dart';
import 'package:naam_jaap/data/sync/sync_snapshot.dart';

/// Stores the snapshot as one JSON file in the user's Google Drive app data
/// folder: a hidden, per-app space that only JaapMala can read or write and
/// that doesn't use or show up in the user's normal Drive files.
class DriveRemoteStore implements RemoteStore {
  DriveRemoteStore(http.Client client) : _api = drive.DriveApi(client);

  static const scopes = [drive.DriveApi.driveAppdataScope];
  static const fileName = 'jaapmala_sync.json';
  static const _folder = 'appDataFolder';

  final drive.DriveApi _api;
  String? _fileId;

  Future<String?> _findFile() async {
    if (_fileId != null) return _fileId;
    final list = await _api.files.list(
      spaces: _folder,
      q: "name = '$fileName' and trashed = false",
      $fields: 'files(id)',
      pageSize: 1,
    );
    return _fileId = list.files?.firstOrNull?.id;
  }

  @override
  Future<SyncSnapshot?> read() async {
    final id = await _findFile();
    if (id == null) return null;
    final media =
        await _api.files.get(id, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
    final body = await utf8.decodeStream(media.stream);
    return SyncSnapshot.fromJson(jsonDecode(body) as Map<String, dynamic>);
  }

  @override
  Future<void> write(SyncSnapshot snapshot) async {
    final bytes = utf8.encode(jsonEncode(snapshot.toJson()));
    final media = drive.Media(Stream.value(bytes), bytes.length, contentType: 'application/json');
    final id = await _findFile();
    if (id == null) {
      final created = await _api.files.create(
        drive.File()
          ..name = fileName
          ..parents = [_folder],
        uploadMedia: media,
        $fields: 'id',
      );
      _fileId = created.id;
    } else {
      await _api.files.update(drive.File(), id, uploadMedia: media);
    }
  }
}
