import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor_shared/src/blocs/todo.dart';

class AddCategoryDialog extends StatefulWidget {
  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Add a category',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Name of the category',
              ),
              onSubmitted: (_) => _addEntry(),
            ),
            ButtonBar(
              children: [
                TextButton(
                  child: const Text('Add'),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                      TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                  onPressed: _addEntry,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addEntry() {
    if (_controller.text.isNotEmpty) {
      BlocProvider.of<TodoAppBloc>(context).addCategory(_controller.text);
      Navigator.of(context).pop();
    }
  }
}
