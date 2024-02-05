Project Structure. 


|-- lib
|   |-- main.dart
|   |-- screens
|       |-- add_todo_screen.dart
|       |-- todo_list_screen.dart
|   |-- blocs
|       |-- todo_bloc.dart
|   |-- models
|       |-- todo.dart
|   |-- repositories
|       |-- todo_repository.dart
|-- test
|   |-- todo_bloc_test.dart



Instructions on How to Set Up and Run the Project:
git clone <repository-url>


Navigate to the project directory:
cd <project-directory>

flutter pub get
flutter pub get


Run the project:
flutter run


Implementation and Architecture:
* The project uses the BLoC (Business Logic Component) pattern for state management. The TodoBloc handles the business logic, and the UI components listen to the state changes.
* The TodoRepository simulates a database and manages the CRUD operations for todo items.
* AddTodoScreen allows users to add new todo items or update existing ones. It uses SharedPreferences for data persistence.
* TodoListScreen displays the list of todos and provides options to mark tasks as completed, delete them, or add new ones.


Running Unit Tests:

Navigate to the project directory:
cd <project-directory>

Run tests:
flutter test



