import 'package:flutter/material.dart';

import '../../data/blocs/bloc.dart';
import '../../data/blocs/provider.dart';
import '../../data/database/database.dart';
import '../common/index.dart';

// ignore_for_file: prefer_const_constructors

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

/// Shows a list of todos and displays a text input to add another one
class HomeScreenState extends State<HomeScreen> {
  // we only use this to reset the input field at the bottom when a entry has been added
  final TextEditingController controller = TextEditingController();

  TodoAppBloc get bloc => BlocProvider.provideBloc(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo list'),
      ),
      drawer: CategoriesDrawer(),
      body: StreamBuilder<List<EntryWithCategory>>(
        stream: bloc.homeScreenEntries,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }

          final activeTodos = snapshot.data;

          return ListView.builder(
            itemCount: activeTodos.length,
            itemBuilder: (context, index) {
              return TodoCard(activeTodos[index].entry);
            },
          );
        },
      ),
      bottomSheet: Material(
        elevation: 12.0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('What needs to be done?'),
                Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onSubmitted: (_) => _createTodoEntry(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        color: Theme.of(context).accentColor,
                        onPressed: _createTodoEntry,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createTodoEntry() {
    if (controller.text.isNotEmpty) {
      // We write the entry here. Notice how we don't have to call setState()
      // or anything - moor will take care of updating the list automatically.
      bloc.createEntry(controller.text);
      controller.clear();
    }
  }
}