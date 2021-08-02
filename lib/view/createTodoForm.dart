import 'package:amplify_demo/providers/todoNotifier.dart';
import 'package:amplify_demo/services/createTodoService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTodoForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TodoNotifier todoNotifier =
        Provider.of<TodoNotifier>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        children: [
          TextField(
            controller: todoNotifier.todoNameController,
            decoration: InputDecoration(hintText: "Todo name"),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: todoNotifier.todoDescController,
            decoration: InputDecoration(hintText: "Todo description"),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () => CreateTodoService.create(context),
            child: Text("ADD"),
          )
        ],
      ),
    );
  }
}
