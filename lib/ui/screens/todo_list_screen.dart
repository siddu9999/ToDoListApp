import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../bloc/todo_bloc.dart';
import '../../models/todo.dart';
import 'add_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late List<bool> isCheckedList;
  late TodoBloc todoBloc;
  late List<Todo> completedTasks;
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    isCheckedList = [];
    completedTasks = [];
    todoBloc = context.read<TodoBloc>();
    dropdownValue = 'Todo List';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo List',
          style: TextStyle(color: Colors.purple),
        ),
        backgroundColor: Colors.grey[300],
        actions: [
          DropdownButton<String>(
            value: dropdownValue,
            items: ['Todo List', 'Completed Task']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
                .toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue ?? 'Todo List';
                if (newValue == 'Completed Task') {
                  completedTasks = [];
                  for (int i = 0; i < isCheckedList.length; i++) {
                    if (isCheckedList[i]) {
                      completedTasks.add((todoBloc.state as TodosLoadedState).todos[i]);
                    }
                  }
                } else {
                  completedTasks = [];
                }
              });
            },
          ),
        ],
      ),
      body: Consumer<TodoBloc>(
        builder: (context, todoBloc, child) {
          final List<Todo> todos = (todoBloc.state as TodosLoadedState).todos;

          if (isCheckedList.length != todos.length) {
            isCheckedList = List.generate(todos.length, (index) => false);
          }

          return (todos.isEmpty)
              ? Center(
            child: Text(
              'Not a single task added yet',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
              : Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListView.builder(
              itemCount: (completedTasks.isNotEmpty) ? completedTasks.length : todos.length,
              itemBuilder: (context, index) {
                final Todo currentTask =
                (completedTasks.isNotEmpty) ? completedTasks[index] : todos[index];

                return Dismissible(
                  key: Key(currentTask.title),
                  onDismissed: (direction) {
                    todoBloc.add(DeleteTodoEvent(currentTask));
                  },
                  background: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                    alignment: Alignment.centerRight,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTodoScreen(
                            initialTitle: currentTask.title,
                            initialDescription: currentTask.description,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Title: ${currentTask.title}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8.0),
                                Text('Description: ${currentTask.description}'),
                              ],
                            ),
                          ),
                          if (completedTasks.isNotEmpty)
                            Container()
                          else
                            IconButton(
                              icon: Icon(isCheckedList[index]
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank),
                              onPressed: () {
                                setState(() {
                                  isCheckedList[index] = !isCheckedList[index];
                                });
                              },
                            ),
                          if (completedTasks.isNotEmpty)
                            Container()
                          else
                            SizedBox(width: 8.0),
                          if (completedTasks.isNotEmpty)
                            Container()
                          else
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                todoBloc.add(DeleteTodoEvent(currentTask));
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoScreen()),
          );
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }
}
