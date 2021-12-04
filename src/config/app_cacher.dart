import 'dart:io';

import 'package:path_provider/path_provider.dart';

//# https://docs.flutter.dev/cookbook/persistence/reading-writing-files
class ManageStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/app_cacher.json');
  }

  Future<String> readCache() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return 'no-cached-data';
    }
  }

  Future<File> writeCache(String cachedata) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(cachedata);
  }
}
