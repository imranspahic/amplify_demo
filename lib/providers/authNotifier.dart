import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/cupertino.dart';

enum LoginType { SignIn, SignUp }

class AuthNotifier with ChangeNotifier {
  AuthNotifier._internal();
  static final AuthNotifier _instance = AuthNotifier._internal();
  factory AuthNotifier() => _instance;

  AuthUser? currentUser;

  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? confirmCodeController;

  bool isUserSignedIn = false;
  bool isUserConfirmed = false;
  bool isInitLoading = true;

  LoginType loginType = LoginType.SignIn;

  bool get isSignUp => loginType == LoginType.SignUp;

  void initializeControllers() {
    emailController = emailController ?? TextEditingController();
    passwordController = passwordController ?? TextEditingController();
    confirmCodeController = confirmCodeController ?? TextEditingController();
  }

  void setUserSignedState(bool state) => isUserSignedIn = state;

  void setInitLoadingState(bool state) {
    isInitLoading = state;
    notifyListeners();
  }

  void toggleLoginType() {
    loginType = LoginType.values[LoginType.values.length - loginType.index - 1];
    notifyListeners();
  }

  void updateAuthState({bool? isUserSignedIn, bool? isUserConfirmed}) {
    if (isUserSignedIn != null) this.isUserSignedIn = isUserSignedIn;
    if (isUserConfirmed != null) this.isUserConfirmed = isUserConfirmed;
    notifyListeners();
  }
}
