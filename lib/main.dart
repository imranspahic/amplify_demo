import 'package:amplify_demo/providers/authNotifier.dart';
import 'package:amplify_demo/providers/todoNotifier.dart';
import 'package:amplify_demo/view/wrapperPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: AuthNotifier()),
          ChangeNotifierProvider.value(value: TodoNotifier())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: WrapperPage(),
        ));
  }
}
