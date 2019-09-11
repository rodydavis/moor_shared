import 'package:moor_flutter/moor_flutter.dart';

import '../database.dart';

Database constructDb({bool logStatements = false}) {
  return Database(FlutterQueryExecutor.inDatabaseFolder(
      path: 'db.sqlite', logStatements: logStatements));
}
