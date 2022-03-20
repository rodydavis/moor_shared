import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart';

import 'package:path_provider/path_provider.dart' as paths;
import 'package:path/path.dart' as p;

import '../database.dart';

Database constructDb({bool logStatements = false}) {
  if (Platform.isIOS || Platform.isAndroid) {
    final executor = LazyDatabase(() async {
      final dataDir = await paths.getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dataDir.path, 'db.sqlite'));
      return NativeDatabase(dbFile, logStatements: logStatements);
    });
    return Database(executor);
  }
  if (Platform.isMacOS || Platform.isLinux) {
    final file = File('db.sqlite');
    return Database(NativeDatabase(file, logStatements: logStatements));
  }
  // if (Platform.isWindows) {
  //   final file = File('db.sqlite');
  //   return Database(VMDatabase(file, logStatements: logStatements));
  // }
  return Database(NativeDatabase.memory(logStatements: logStatements));
}
