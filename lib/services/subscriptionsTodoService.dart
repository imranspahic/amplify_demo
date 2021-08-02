import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_demo/providers/todoNotifier.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SubscriptionsTodoService {
  static Future<void> setSubscriptions(BuildContext context) async {
    final TodoNotifier todoNotifier =
        Provider.of<TodoNotifier>(context, listen: false);
    String onCreateSubscription = '''subscription MySubscription {
  onCreateTodo {
    id
    description
    name
    userID
  }
} ''';
    try {
      todoNotifier.createSubscription = Amplify.API.subscribe(
          request: GraphQLRequest<String>(document: onCreateSubscription),
          onData: (event) {
            print(jsonDecode(event.data.toString()));
            todoNotifier
                .addTodo(jsonDecode(event.data.toString())["onCreateTodo"]);
          },
          onEstablished: () {
            print("established subscription");
          },
          onError: (error) {
            print("on error here $error");
          },
          onDone: () {
            print("done subscription");
          });
    } catch (e) {
      print(e);
    }
  }
}
