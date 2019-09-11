import 'dart:io';

import 'package:moor_flutter/moor_flutter.dart';
import 'package:moor/moor_vm.dart';

import '../database.dart';

Database constructDb({bool logStatements = false}) {
  if (Platform.isIOS || Platform.isAndroid) {
    return Database(FlutterQueryExecutor.inDatabaseFolder(
        path: 'db.sqlite', logStatements: logStatements));
  }
  // if (Platform.isMacOS || Platform.isLinux) {
  //   final _path = Directory('${Platform.environment['HOME']}/.config');
  //   final _file = File('$_path.sqlite');
  //   return Database(VMDatabase(_file, logStatements: logStatements));
  // } else if (Platform.isWindows) {
  //   final _path = Directory('${Platform.environment['UserProfile']}\\.config');
  //   final _file = File('$_path.sqlite');
  //   return Database(VMDatabase(_file, logStatements: logStatements));
  // }
  return Database(VMDatabase.memory(logStatements: logStatements));
}
