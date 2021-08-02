import 'package:amplify_demo/providers/todoNotifier.dart';
import 'package:amplify_demo/services/deleteTodoService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    final TodoNotifier todoNotifier = Provider.of<TodoNotifier>(context);
    return Scrollbar(
      isAlwaysShown: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                ...todoNotifier.todos
                    .map((e) => Dismissible(
                          key: Key(e.id),
                          background: Container(
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.delete,
                                    color: Colors.white, size: 40),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) =>
                              DeleteTodoService.delete(context, e.id),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Todo ID:"),
                                  Text(e.id.substring(0, 10))
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text("Todo Name:"), Text(e.name)],
                              ),
                              SizedBox(height: 5),
                              if (e.description != null)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Todo Description:"),
                                    Text(e.description!)
                                  ],
                                ),
                              SizedBox(height: 5),
                              Divider(),
                              SizedBox(height: 5),
                            ],
                          ),
                        ))
                    .toList(),
                SizedBox(height: 60),
              ]),
        ),
      ),
    );
  }
}
