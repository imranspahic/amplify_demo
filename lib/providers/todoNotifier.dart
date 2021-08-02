import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_demo/models/Todo.dart';
import 'package:flutter/cupertino.dart';

class TodoNotifier with ChangeNotifier {
  TodoNotifier._internal();
  static final TodoNotifier _instance = TodoNotifier._internal();
  factory TodoNotifier() => _instance;

  List<Todo> todos = [];

  TextEditingController? todoNameController;
  TextEditingController? todoDescController;

  GraphQLSubscriptionOperation? createSubscription;

  void initializeControllers() {
    todoNameController = todoNameController ?? TextEditingController();
    todoDescController = todoDescController ?? TextEditingController();
  }

  void addTodo(Map<String, dynamic> jsonData) {
    if (!todos.any((element) => element.id == jsonData["id"])) {
      todos.add(Todo.fromJson(jsonData));
      notifyListeners();
    }
  }
}
