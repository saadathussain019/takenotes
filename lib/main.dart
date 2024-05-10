//imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:takenotes/firebase_options.dart';
import 'package:takenotes/views/login_view.dart';
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
      routes:{
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}

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
            if (user != null){
              if(user.emailVerified){
                print('E-mail is verified!');
              } else{
              return const VerifyEmailView();
            }
            } else{
              return const LoginView();
            }
            return const Text ("Done!");
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
*/