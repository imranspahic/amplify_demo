import 'package:amplify_demo/providers/authNotifier.dart';
import 'package:amplify_demo/services/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthConfirmationPage extends StatefulWidget {
  const AuthConfirmationPage({Key? key}) : super(key: key);

  @override
  _AuthConfirmationPageState createState() => _AuthConfirmationPageState();
}

class _AuthConfirmationPageState extends State<AuthConfirmationPage> {
  @override
  void initState() {
    Provider.of<AuthNotifier>(context, listen: false).initializeControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text("Enter confirmation code from email"),
          SizedBox(height: 10),
          TextField(
            controller: authNotifier.confirmCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Confirmation code"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
              onPressed: () => AuthService.confirmSignUp(context),
              child: Text("CONFIRM"))
        ],
      ),
    );
  }
}
