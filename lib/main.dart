//imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:takenotes/firebase_options.dart';
import 'package:takenotes/views/login_view.dart';
import 'package:takenotes/views/register_view.dart';
import 'package:takenotes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

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
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/notes/': (context) => const NotesView(),
      },
    ),
  );
}

//homepage view
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
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

//Menu Action
enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesView();
}

class _NotesView extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Main UI'),
          actions: [
            PopupMenuButton<MenuAction>(
              //Popup Menu Button
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    devtools.log(shouldLogout.toString());
                    switch (shouldLogout) {
                      case true:
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/login/", (_) => false);
                      case false:
                        break;
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text('Logout')),
                ];
              },
            )
          ],
          foregroundColor: Colors.white,
          backgroundColor: Colors.purple),
      body: const Text('Hello World!'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout'),
            )
          ],
        );
      }).then((value) => value ?? false);
}


/*
dependencies added in pubspec.yaml
  cupertino_icons: ^1.0.6
  firebase_core: ^2.30.1
  firebase_auth: ^4.19.4
  cloud_firestore: ^4.17.2
  firebase_analytics: ^10.10.4
*/