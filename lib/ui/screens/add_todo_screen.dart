import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../../bloc/todo_bloc.dart';
import '../../models/todo.dart';

class AddTodoScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final String? initialTitle;
  final String? initialDescription;

  AddTodoScreen({this.initialTitle, this.initialDescription}) {
    // Set initial values if provided
    if (initialTitle != null) {
      _titleController.text = initialTitle!;
    }
    if (initialDescription != null) {
      _descriptionController.text = initialDescription!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Todo',
          style: TextStyle(color: Colors.purple),
        ),
        backgroundColor: Colors.grey[300], // Set AppBar color to light grey
        centerTitle: true, // Center the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Conditionally call _addTodo or _updateTodo
                if (initialTitle == null || initialDescription == null) {
                  _addTodo(context);
                } else {
                  _updateTodo(context);
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green[700], // Set button color to dark green
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _addTodo(BuildContext context) async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty) {
      try {
        // Save the todo data using SharedPreferences
        await _saveTodoData(title, description);

        // Access the TodoBloc and add the new todo
        context.read<TodoBloc>().add(AddTodoEvent(Todo(
          title: title,
          description: description,
        )));

        // Navigate back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        print('Error saving todo data: $e');
        // Handle the error, show a message, or take appropriate action
      }
    } else {
      // Show an error message if either title or description is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both title and description.'),
        ),
      );
    }
  }

  void _updateTodo(BuildContext context) async {
    final String updatedTitle = _titleController.text.trim();
    final String updatedDescription = _descriptionController.text.trim();

    if (updatedTitle.isNotEmpty && updatedDescription.isNotEmpty) {
      try {
        // Dispatch UpdateTodoEvent
        context.read<TodoBloc>().add(UpdateTodoEvent(
          Todo(
            title: initialTitle!,
            description: initialDescription!,
          ),
          Todo(
            title: updatedTitle,
            description: updatedDescription,
          ),
        ));

        // Navigate back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        print('Error updating todo data: $e');
        // Handle the error, show a message, or take appropriate action
      }
    } else {
      // Show an error message if either title or description is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both title and description.'),
        ),
      );
    }
  }

  Future<void> _saveTodoData(String title, String description) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Use a unique key for each todo to store in SharedPreferences
    final String todoKey = 'todo_$title';
    prefs.setString(todoKey, description);
  }

  Future<void> _updateTodoData(String initialTitle, String updatedTitle, String updatedDescription) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the old todo data using the initial title
    final String initialTodoKey = 'todo_$initialTitle';
    prefs.remove(initialTodoKey);

    // Save the updated todo data using the updated title
    final String updatedTodoKey = 'todo_$updatedTitle';
    prefs.setString(updatedTodoKey, updatedDescription);
  }
}