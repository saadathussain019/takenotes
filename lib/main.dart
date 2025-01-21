//imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takenotes/constants/routes.dart';
import 'package:takenotes/helpers/loading/loading_screen.dart';
import 'package:takenotes/services/auth/bloc/auth_bloc.dart';
import 'package:takenotes/services/auth/bloc/auth_event.dart';
import 'package:takenotes/services/auth/bloc/auth_state.dart';
import 'package:takenotes/services/auth/firebase_auth_provider.dart';
import 'package:takenotes/views/forgot_password_view.dart';
import 'package:takenotes/views/login_view.dart';
import 'package:takenotes/views/notes/create_update_note_view.dart';
import 'package:takenotes/views/notes/notes_view.dart';
import 'package:takenotes/views/register_view.dart';
import 'package:takenotes/views/verify_email_view.dart';

//driver:
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Take Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        //Routes below no longer needed as shifted to Bloc State Manangement
        // loginRoute: (context) => const LoginView(),
        // registerRoute: (context) => const RegisterView(),
        // notesRoute: (context) => const NotesView(),
        // verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(body: CircularProgressIndicator());
        }
      },
    );
  }
}
/*
dependencies added in pubspec.yaml
  cupertino_icons: ^1.0.6
  firebase_core: ^2.30.1
  firebase_auth: ^4.19.4
  cloud_firestore: ^4.17.2 
  firebase_analytics: ^10.10.4
  sqflite: ^2.3.3+1
  path_provider: ^2.1.3
  path: ^1.9.0
*/