import 'package:amplify_demo/providers/authNotifier.dart';
import 'package:amplify_demo/services/authService.dart';
import 'package:amplify_demo/services/createTodoService.dart';
import 'package:amplify_demo/view/authConfirmationPage.dart';
import 'package:amplify_demo/view/authLoginPage.dart';
import 'package:amplify_demo/view/todoPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WrapperPage extends StatefulWidget {
  const WrapperPage({Key? key}) : super(key: key);

  @override
  _WrapperPageState createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
  @override
  void initState() {
    AuthService.checkLoginSession(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Amplify DEMO"),
        centerTitle: true,
        actions: [
          if (authNotifier.isUserSignedIn && authNotifier.isUserConfirmed)
            TextButton(
                onPressed: () => AuthService.logout(context),
                child: Text("LOGOUT", style: TextStyle(color: Colors.red[100])))
        ],
      ),
      floatingActionButton:
          authNotifier.isUserSignedIn && authNotifier.isUserConfirmed
              ? FloatingActionButton(
                  onPressed: () => CreateTodoService.showAddDialog(context),
                  child: Icon(Icons.add),
                )
              : null,
      body: authNotifier.isInitLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : authNotifier.isUserSignedIn
              ? authNotifier.isUserConfirmed
                  ? TodoPage()
                  : AuthConfirmationPage()
              : AuthLoginPage(),
    );
  }
}
