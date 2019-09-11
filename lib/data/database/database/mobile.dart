import 'dart:io';

import 'package:moor_flutter/moor_flutter.dart';
import 'package:moor/moor_vm.dart';

import '../database.dart';

Database constructDb({bool logStatements = false}) {
  if (Platform.isIOS || Platform.isAndroid) {
    return Database(FlutterQueryExecutor.inDatabaseFolder(
        path: 'db.sqlite', logStatements: logStatements));
  }
  if (Platform.isMacOS || Platform.isLinux) {
    final file = File('db.sqlite');
    return Database(VMDatabase(file, logStatements: logStatements));
  }
  // if (Platform.isWindows) {
  //   final file = File('db.sqlite');
  //   return Database(VMDatabase(file, logStatements: logStatements));
  // }
  return Database(VMDatabase.memory(logStatements: logStatements));
}
