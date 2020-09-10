import 'package:moor/moor.dart';
import 'package:undo/undo.dart';

extension TableUtils on GeneratedDatabase {
  Future<void> deleteRow(
    ChangeStack cs,
    Table table,
    Insertable val,
  ) async {
    final _change = Change(
      val,
      () async => await this.delete(table).delete(val),
      (old) async => await this.into(table).insert(old),
    );
    await cs.add(_change);
  }

  Future<void> insertRow(
    ChangeStack cs,
    Table table,
    Insertable val,
  ) async {
    final _change = Change(
      val,
      () async => await this.into(table).insert(val),
      (val) async => await this.delete(table).delete(val),
    );
    await cs.add(_change);
  }

  Future<void> updateRow(
    ChangeStack cs,
    Table table,
    Insertable val,
  ) async {
    final oldVal = await (select(table)..whereSamePrimaryKey(val)).getSingle();
    final _change = Change(
      oldVal,
      () async => await this.update(table).replace(val),
      (old) async => await this.update(table).replace(old),
    );
    await cs.add(_change);
  }
}

Value<T> addField<T>(T val, {T fallback}) {
  Value<T> _fallback;
  if (fallback != null) {
    _fallback = Value<T>(fallback);
  }
  if (val == null) {
    return _fallback ?? Value.absent();
  }
  if (val is String && (val == 'null' || val == 'Null')) {
    return _fallback ?? Value.absent();
  }
  return Value(val);
}
