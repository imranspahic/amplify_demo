import 'package:amplify_demo/providers/authNotifier.dart';
import 'package:amplify_demo/services/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthLoginPage extends StatefulWidget {
  @override
  _AuthLoginPageState createState() => _AuthLoginPageState();
}

class _AuthLoginPageState extends State<AuthLoginPage> {
  @override
  void initState() {
    Provider.of<AuthNotifier>(context, listen: false).initializeControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(authNotifier.isSignUp ? "Sign up" : "Sign in",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(height: 10),
          TextField(
            controller: authNotifier.emailController,
            decoration: InputDecoration(hintText: "Email"),
          ),
          SizedBox(height: 5),
          TextField(
            controller: authNotifier.passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: "Password"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
              onPressed: authNotifier.isSignUp
                  ? () => AuthService.signUp(context)
                  : () => AuthService.signIn(context),
              child: Text(authNotifier.isSignUp ? "Sign up" : "Sign in")),
          TextButton(
              onPressed: authNotifier.toggleLoginType,
              child: Text(authNotifier.isSignUp
                  ? "Sign in instead"
                  : "Sign up instead"))
        ],
      ),
    );
  }
}
