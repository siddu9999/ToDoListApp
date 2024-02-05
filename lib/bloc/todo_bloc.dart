import 'dart:async';
import 'package:bloc/bloc.dart';
import '../data/todo_repository.dart';
import '../models/todo.dart';

// Events
abstract class TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final Todo todo;
  AddTodoEvent(this.todo);
}

class DeleteTodoEvent extends TodoEvent {
  final Todo todo;
  DeleteTodoEvent(this.todo);
}

// Inside your events
class UpdateTodoEvent extends TodoEvent {
  final Todo oldTodo;
  final Todo updatedTodo;

  UpdateTodoEvent(this.oldTodo, this.updatedTodo);
}



// States
abstract class TodoState {}

class TodosLoadedState extends TodoState {
  final List<Todo> todos;
  TodosLoadedState(this.todos);
}

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository = TodoRepository();

  TodoBloc() : super(TodosLoadedState([])) {
    on<AddTodoEvent>(_onAddTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
  }

  void _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) {
    repository.addTodo(event.todo);
    emit(TodosLoadedState(repository.getTodos()));
  }

  void _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) {
    repository.deleteTodo(event.todo);
    emit(TodosLoadedState(repository.getTodos()));
  }

  void _onUpdateTodo(UpdateTodoEvent event, Emitter<TodoState> emit) {
    repository.updateTodo(event.oldTodo, event.updatedTodo);
    emit(TodosLoadedState(repository.getTodos()));
  }

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    // Existing implementation (if any)
    if (event is AddTodoEvent) {
      // Note: The event is now handled by _onAddTodo
      // This block can be empty or used for other events
    } else if (event is DeleteTodoEvent) {
      // Note: The event is now handled by _onDeleteTodo
      // This block can be empty or used for other events
    } else if (event is UpdateTodoEvent) {
      // Note: The event is now handled by _onUpdateTodo
      // This block can be empty or used for other events
    }

    // Emit the updated state
    yield TodosLoadedState(repository.getTodos());
  }
}
