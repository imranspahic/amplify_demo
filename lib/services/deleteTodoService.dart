import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_demo/providers/authNotifier.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteTodoService {
  static Future<void> delete(BuildContext context, String todoID) async {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    String deleteToDoDocument = '''mutation MyMutation {
  deleteTodo(input: {id: "$todoID", userID: "${authNotifier.currentUser?.userId}"}) {
    description
    name
    id
    userID
  }
}
 ''';

 print(deleteToDoDocument);

    GraphQLOperation deleteOperation = Amplify.API
        .query(request: GraphQLRequest<String>(document: deleteToDoDocument));
    await deleteOperation.response;
  }
}
