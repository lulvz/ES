// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:recipe_wizard/ui/home/home_page.dart';
import 'package:recipe_wizard/ui/authenticate/authenticate_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// this wrapper a standard way to handle authentication, inspiration
// was taken directly from the flutter provider package documentation
// which goes over a similar example
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    print("user: $user");
    if (user != null) {
      return const HomePage(
        key: Key("home_page"), 
        title: "Home Page",
      );
    } else {
      return const AuthenticatePage(
        key: Key("authenticate"), 
        title: "Authenticate"
      );
    }
  }
}