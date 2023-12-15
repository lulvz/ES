import 'package:flutter/material.dart';
import 'package:recipe_wizard/ui/authenticate/sign_in.dart';
import 'package:recipe_wizard/ui/authenticate/register.dart';
class AuthenticatePage extends StatefulWidget {
  const AuthenticatePage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AuthenticatePage> createState() => _AuthenticatePage();
}

class _AuthenticatePage extends State<AuthenticatePage> {

  bool showSignIn = true;

  void switchView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignInPage(
        key: const Key('SignInPage'),
        s: switchView,
      );
    } else {
      return RegisterPage(
        key: const Key('RegisterPage'),
        changeView: switchView,
      );
    }
  }
}