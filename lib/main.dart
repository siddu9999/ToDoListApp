import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/ui/screens/todo_list_screen.dart';

import 'bloc/todo_bloc.dart';
import 'data/todo_repository.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (context) => TodoBloc()),  // Change here
        Provider(create: (context) => TodoRepository()),
      ],
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      home: TodoListScreen(),
    );
  }
}


