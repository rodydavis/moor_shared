import 'package:flutter/material.dart';

import 'data/blocs/bloc.dart';
import 'data/blocs/provider.dart';
import 'plugins/desktop/desktop.dart';
import 'ui/home/screen.dart';

void main() {
  setTargetPlatformForDesktop();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TodoAppBloc bloc;

  @override
  void initState() {
    bloc = TodoAppBloc();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: MaterialApp(
        title: 'moor Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          // use the good-looking updated material text style
          typography: Typography(
            englishLike: Typography.englishLike2018,
            dense: Typography.dense2018,
            tall: Typography.tall2018,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
