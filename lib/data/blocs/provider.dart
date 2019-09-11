import 'package:flutter/material.dart';

import 'bloc.dart';

class BlocProvider extends InheritedWidget {
  final TodoAppBloc bloc;

  BlocProvider({@required this.bloc, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(BlocProvider oldWidget) {
    return oldWidget.bloc != bloc;
  }

  static TodoAppBloc provideBloc(BuildContext ctx) =>
      (ctx.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider).bloc;
}
