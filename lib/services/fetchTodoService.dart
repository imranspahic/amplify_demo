import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_demo/models/Todo.dart';
import 'package:amplify_demo/providers/authNotifier.dart';
import 'package:amplify_demo/providers/todoNotifier.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FetchTodoService {
  static Future<void> fetchTodos(BuildContext context) async {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    final TodoNotifier todoNotifier =
        Provider.of<TodoNotifier>(context, listen: false);
    String fetchingQuery = '''query MyQuery {
  listTodos(filter: {userID: {eq: "${authNotifier.currentUser?.userId}"}}) {
    items {
      description
      id
      name
      userID
    }
  }
}
''';

    try {
      GraphQLOperation graphQLOperation =
          Amplify.API.query(request: GraphQLRequest(document: fetchingQuery));
      GraphQLResponse graphQLResponse = await graphQLOperation.response;
      print(graphQLResponse.data);
      if (graphQLResponse.errors.isEmpty) {
        List<dynamic> todosResponse =
            jsonDecode(graphQLResponse.data)["listTodos"]["items"];
        todosResponse.forEach((todo) {
          if (!todoNotifier.todos.any((element) => element.id == todo["id"]))
            todoNotifier.todos.add(Todo.fromJson(todo));
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
