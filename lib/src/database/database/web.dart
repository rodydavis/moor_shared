import 'package:drift/web.dart';

import '../database.dart';

Database constructDb({bool logStatements = false}) {
  return Database(WebDatabase('db', logStatements: logStatements));
}
