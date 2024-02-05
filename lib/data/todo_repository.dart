import '../models/todo.dart';

class TodoRepository {
  // A simple list to simulate a database
  List<Todo> _todos = [];

  List<Todo> getTodos() {
    return _todos;
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
  }

  void updateTodo(Todo oldTodo, Todo updatedTodo) {
    // Find the old todo and update its values
    final index = _todos.indexWhere((todo) => todo.title == oldTodo.title);
    if (index != -1) {
      _todos[index] = updatedTodo;
    }
  }

  void deleteTodo(Todo todo) {
    // Assuming 'title' is a unique identifier for todos
    _todos.removeWhere((existingTodo) => existingTodo.title == todo.title);
  }
}
