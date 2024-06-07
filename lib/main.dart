//imports
import 'package:flutter/material.dart';
import 'package:takenotes/constants/routes.dart';
import 'package:takenotes/services/auth/auth_service.dart';
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
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
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