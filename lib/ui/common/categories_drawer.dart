import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:moor_shared/src/database/database.dart';

import '../../src/blocs/todo.dart';
import 'index.dart';

class CategoriesDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DrawerHeader(
            child: TextButton(
              onPressed: () {
                final db = RepositoryProvider.of<Database>(context);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MoorDbViewer(db),
                  ),
                );
              },
              child: Text(
                'Todo-List Demo with moor',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(color: Colors.orange),
          ),
          Flexible(
            child: StreamBuilder<List<CategoryWithActiveInfo>>(
              stream: BlocProvider.of<TodoAppBloc>(context).categories,
              builder: (context, snapshot) {
                final categories = snapshot.data ?? <CategoryWithActiveInfo>[];

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return _CategoryDrawerEntry(entry: categories[index]);
                  },
                  itemCount: categories.length,
                );
              },
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              TextButton(
                child: const Text('Add category'),
                // textColor: Theme.of(context).accentColor,
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                    TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context, builder: (_) => AddCategoryDialog());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryDrawerEntry extends StatelessWidget {
  final CategoryWithActiveInfo? entry;

  const _CategoryDrawerEntry({Key? key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = entry!.categoryWithCount.category;
    String title;
    if (category == null) {
      title = 'No category';
    } else {
      title = category.description ?? 'Unnamed';
    }

    final isActive = entry!.isActive;
    final bloc = BlocProvider.of<TodoAppBloc>(context);

    final rowContent = [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isActive ? Theme.of(context).accentColor : Colors.black,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('${entry!.categoryWithCount.count} entries'),
      ),
    ];

    // also show a delete button if the category can be deleted
    if (category != null) {
      rowContent.addAll([
        Spacer(),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Colors.red,
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete'),
                  content: Text('Really delete category $title?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    TextButton(
                      child: const Text('Delete'),
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.red),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                );
              },
            );

            if (confirmed == true) {
              // can be null when the dialog is dismissed
              bloc.deleteCategory(category);
            }
          },
        ),
      ]);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        color: isActive
            ? Colors.orangeAccent.withOpacity(0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            bloc.showCategory(entry!.categoryWithCount.category);
            Navigator.pop(context); // close the navigation drawer
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: rowContent,
            ),
          ),
        ),
      ),
    );
  }
}
