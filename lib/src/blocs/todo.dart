import 'package:bloc/bloc.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart';
import 'package:undo/undo.dart';

import '../database/database.dart';

/// Class that keeps information about a category and whether it's selected at
/// the moment.
class CategoryWithActiveInfo {
  CategoryWithActiveInfo(this.categoryWithCount, this.isActive);

  CategoryWithCount categoryWithCount;
  bool isActive;
}

class TodoAppBloc extends Cubit<ChangeStack> {
  TodoAppBloc(this.db) : super(db.cs) {
    init();
  }

  final Database db;

  // the category that is selected at the moment. null means that we show all
  // entries
  final BehaviorSubject<Category?> _activeCategory =
      BehaviorSubject.seeded(null);

  final BehaviorSubject<List<CategoryWithActiveInfo>> _allCategories =
      BehaviorSubject();

  Stream<List<EntryWithCategory>>? _currentEntries;

  /// A stream of entries that should be displayed on the home screen.
  Stream<List<EntryWithCategory>>? get homeScreenEntries => _currentEntries;

  Stream<List<CategoryWithActiveInfo>> get categories => _allCategories;

  void init() {
    // listen for the category to change. Then display all entries that are in
    // the current category on the home screen.
    _currentEntries = _activeCategory.switchMap(db.watchEntriesInCategory);

    // also watch all categories so that they can be displayed in the navigation
    // drawer.
    Rx.combineLatest2<List<CategoryWithCount>, Category?,
        List<CategoryWithActiveInfo>>(
      db.categoriesWithCount(),
      _activeCategory,
      (allCategories, selected) {
        return allCategories.map((category) {
          final isActive = selected?.id == category.category?.id;

          return CategoryWithActiveInfo(category, isActive);
        }).toList();
      },
    ).listen(_allCategories.add);
    emit(db.cs);
  }

  void showCategory(Category? category) {
    _activeCategory.add(category);
  }

  void addCategory(String description) async {
    final id = await db.createCategory(description);
    emit(db.cs);
    showCategory(Category(id: id, description: description));
  }

  void createEntry(String content) async {
    await db.createEntry(TodosCompanion(
      content: Value(content),
      category: Value(_activeCategory.value?.id),
    ));
    emit(db.cs);
  }

  void updateEntry(TodoEntry entry) async {
    db.updateEntry(entry);
    emit(db.cs);
  }

  void deleteEntry(TodoEntry entry) async {
    db.deleteEntry(entry);
    emit(db.cs);
  }

  void deleteCategory(Category category) async {
    // if the category being deleted is the one selected, reset that db by
    // showing the entries who aren't in any category
    if (_activeCategory.value?.id == category.id) {
      showCategory(null);
    }

    await db.deleteCategory(category);
    emit(db.cs);
  }

  bool get canUndo => db.cs.canUndo;
  void undo() {
    db.cs.undo();
    emit(db.cs);
  }

  bool get canRedo => db.cs.canRedo;
  void redo() {
    db.cs.redo();
    emit(db.cs);
  }

  void clear() {
    db.cs.clearHistory();
    emit(db.cs);
  }

  void dispose() {
    _allCategories.close();
  }
}
