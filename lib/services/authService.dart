import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_demo/amplifyconfiguration.dart';
import 'package:amplify_demo/providers/authNotifier.dart';
import 'package:amplify_demo/providers/todoNotifier.dart';
import 'package:amplify_demo/services/fetchTodoService.dart';
import 'package:amplify_demo/services/subscriptionsTodoService.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AuthService {
  static Future<bool> signIn(BuildContext context) async {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    final String email = authNotifier.emailController?.text ?? "";
    final String password = authNotifier.passwordController?.text ?? "";
    print("email = $email, password = $password");
    if (email.isEmpty || password.isEmpty) return false;
    try {
      SignInResult signInResult =
          await Amplify.Auth.signIn(username: email, password: password);
      print("Sign in successful = ${signInResult.isSignedIn} ");
      authNotifier.currentUser = await Amplify.Auth.getCurrentUser();
      SubscriptionsTodoService.setSubscriptions(context);
      await FetchTodoService.fetchTodos(context);
      authNotifier.updateAuthState(
        isUserSignedIn: true,
        isUserConfirmed: true,
      );
      return true;
    } on UserNotConfirmedException catch (_) {
      await Amplify.Auth.resendSignUpCode(username: email);
      authNotifier.updateAuthState(
        isUserSignedIn: true,
        isUserConfirmed: false,
      );
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<void> signUp(BuildContext context) async {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    final String email = authNotifier.emailController!.text;
    final String password = authNotifier.passwordController!.text;
    Map<String, String> userAttributes = {"email": email};
    try {
      SignUpResult signUpResult = await Amplify.Auth.signUp(
          username: email,
          password: password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));
      print("Sign up successful = ${signUpResult.isSignUpComplete}");
      authNotifier.updateAuthState(
          isUserSignedIn: true, isUserConfirmed: false);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> confirmSignUp(BuildContext context) async {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    final String? code = authNotifier.confirmCodeController?.text;
    final String email = authNotifier.emailController!.text;
    if (code == null) return;
    try {
      SignUpResult signUpResult = await Amplify.Auth.confirmSignUp(
          username: email, confirmationCode: code);
      print("Confirmed successfully = ${signUpResult.isSignUpComplete}");
      final bool result = await signIn(context);
      if (result) throw Exception("Sign in exception");
      authNotifier.updateAuthState(isUserConfirmed: true);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> logout(BuildContext context) async {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    final TodoNotifier todoNotifier =
        Provider.of<TodoNotifier>(context, listen: false);
    try {
      await Amplify.Auth.signOut();
      authNotifier.confirmCodeController?.clear();
      todoNotifier.createSubscription?.cancel();
      todoNotifier.todos = [];
      authNotifier.updateAuthState(
          isUserSignedIn: false, isUserConfirmed: false);
      print("Logout successfully");
    } catch (e) {
      print(e);
    }
  }

  static Future<void> checkLoginSession(BuildContext context) async {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    try {
      await Future.delayed(Duration(seconds: 1));
      try {
        if (!Amplify.isConfigured) {
          AmplifyAuthCognito amplifyAuthCognito = AmplifyAuthCognito();
          AmplifyAPI amplifyAPI = AmplifyAPI();
          Amplify.addPlugins([amplifyAuthCognito, amplifyAPI]);
          await Amplify.configure(amplifyconfig);
        }
      } catch (e) {
        print("Error configuring Amplify: $e");
        return;
      }
      AuthSession authSession = await Amplify.Auth.fetchAuthSession();
      if (authSession.isSignedIn) {
        authNotifier.currentUser = await Amplify.Auth.getCurrentUser();
        SubscriptionsTodoService.setSubscriptions(context);
        await FetchTodoService.fetchTodos(context);
        authNotifier.updateAuthState(
            isUserSignedIn: true, isUserConfirmed: true);
      }
    } catch (e) {
      print(e);
    }
    authNotifier.setInitLoadingState(false);
  }
}
