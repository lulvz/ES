// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:recipe_wizard/services/auth.dart';

// standard way of handling authentication, the provider documentation
// goes over a similar situation, so the code is inspireda bit by that
class SignInPage extends StatefulWidget {
  final Function switchView;

  const SignInPage({Key? key, required Function s}) : switchView = s, super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignInPage> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  // password field state
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: const Key("login_page"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
        child: Container(
            key: const Key('login_form'), 
        child: Form(
          // key: const Key('login_form'),
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 120.0,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/recipe_wizard_logo.png'),
                    radius: 100.0,
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              const Text(
                'Sign In',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40.0),
              TextFormField(
                key: const Key('email_field'),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                ),
                validator: (val) =>
                    val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                key: const Key('password_field'),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                ),
                validator: (val) => val!.length < 6
                    ? 'Your password should have at least 6 characters'
                    : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                key: const Key('login_button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if(_formKey.currentState!.validate()) {
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if(result == null) {
                      print('error signing in');
                    }
                    print(email);
                    print(password);
                  }
                },
              ),
              // small button to switch to sign up page
              TextButton(
                key: const Key('switch_to_register_button'),
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                onPressed: () {
                  widget.switchView();
                },
              ),
            ],
          )
        ),
        ),
      ),
    );
  }
}