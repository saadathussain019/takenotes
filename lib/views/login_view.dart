//Imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takenotes/constants/routes.dart';
import 'package:takenotes/services/auth/auth_exceptions.dart';
import 'package:takenotes/services/auth/bloc/auth_bloc.dart';
import 'package:takenotes/services/auth/bloc/auth_event.dart';
import 'package:takenotes/services/auth/bloc/auth_state.dart';
import 'package:takenotes/utilities/dialogs/error_dialog.dart';

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
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) async {
                if (state is AuthStateLoggedOut) {
                  if (state.exception is UserNotFoundAuthException) {
                    await showErrorDialog(context, 'User not found');
                  } else if (state.exception
                      is InvalidCredentialsAuthException) {
                    await showErrorDialog(context, 'Invalid credentials');
                  } else if (state.exception is NoCredentialsAuthException) {
                    await showErrorDialog(
                        context, 'Username or password not entered');
                  } else if (state.exception is InvalidEmailAuthException) {
                    await showErrorDialog(context, 'Invalid email');
                  } else if (state.exception is GenericAuthException) {
                    await showErrorDialog(context, 'Authentication error');
                  }
                }
              },
              child: TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );
                },
                child: const Text('Login'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Not registered yet! Click to Sign Up!'),
            )
          ],
        ),
      ),
    );
  }
}
