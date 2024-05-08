//Imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:takenotes/firebase_options.dart';

// RegisterView:
class RegisterView extends StatefulWidget {
  const RegisterView
({super.key});

  @override
  State<RegisterView> createState() => _RegisterView();
}

class _RegisterView extends State<RegisterView> {
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
        title: const Text('Register'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: 'Enter your Email'),
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
                          final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email,
                                password: password
                              );
                          print(userCredential);
                        } on FirebaseAuthException catch(e){
                          if (e.code == 'weak-password'){
                            print("Weak Password, Please enter a stronger password!");
                          }
                          else if (e.code == 'email-already-in-use'){
                            print("Email is already in use!");
                          }
                          else if (e.code == 'invalid-email'){
                            print("Enter a valid E-mail");
                          }
                          else{
                            print(e.code);
                          }
                        }
                      },
                      child: const Text("Sign Up")),
                ],
              );
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}