//Imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

//LogIn View class:
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Enter your Email'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: 'Enter your Password'),
            ),
            TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/notes/',
                      (route) => false,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      devtools.log("User not found!");
                    } else if (e.code == 'invalid-credential') {
                      devtools.log('Wrong Username or Password');
                    } else {
                      devtools.log(e.code.toString());
                    }
                  }
                  // catch (e) {
                  //   print('Something bad happened..');
                  //   print(e);
                  //   print(e.runtimeType);
                  // }
                },
                child: const Text("Log In")),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/register/', (route) => false);
              },
              child: const Text('Not registered yet! Click to Sign Up!'),
            )
          ],
        ),
      ),
    );
  }
}
