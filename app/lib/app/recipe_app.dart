import 'package:flutter/material.dart';
import 'package:recipe_wizard/services/auth.dart';
import 'package:recipe_wizard/ui/wrapper.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class RecipeApp extends StatelessWidget {
  const RecipeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamProvider<User?>.value(
              value: AuthService().user,
              initialData: null,
              child: MaterialApp(
                home: Wrapper(),
              ),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
