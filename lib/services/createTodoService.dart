import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_demo/providers/authNotifier.dart';
import 'package:amplify_demo/providers/todoNotifier.dart';
import 'package:amplify_demo/view/createTodoForm.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTodoService {
  static Future<void> showAddDialog(BuildContext context) async {
    final TodoNotifier todoNotifier =
        Provider.of<TodoNotifier>(context, listen: false);
    todoNotifier.initializeControllers();
    return showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return CreateTodoForm();
        });
  }

  static Future<void> create(BuildContext context) async {
    final TodoNotifier todoNotifier =
        Provider.of<TodoNotifier>(context, listen: false);
    final AuthNotifier userNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    final String todoName = todoNotifier.todoNameController?.text ?? "";
    final String todoDescription = todoNotifier.todoDescController?.text ?? "";
    if (todoName.isEmpty || todoDescription.isEmpty) return;
    final String createToDoDocument = '''mutation MyMutation {
  createTodo(input: {description: "$todoDescription", name: "$todoName", userID: "${userNotifier.currentUser?.userId}"}) {
    name
    userID
    id
    description
  }
}

''';
    print("createToDoDocument = $createToDoDocument");
    try {
      GraphQLOperation createOperation = Amplify.API
          .query(request: GraphQLRequest<String>(document: createToDoDocument));
      await createOperation.response;
      print("Successfull!");
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }
}
