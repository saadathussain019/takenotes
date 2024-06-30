//imports
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
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

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthService.firebase().initialize(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;
//             if (user != null) {
//               if (user.isEmailVerified) {
//                 return const NotesView();
//               } else {
//                 return const VerifyEmailView();
//               }
//             } else {
//               return const LoginView();
//             }
//           default:
//             return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Testing bloc'),
          backgroundColor: Colors.blue[100],
        ),
        body:
            BlocConsumer<CounterBloc, CounterState>(listener: (context, state) {
          _controller.clear();
        }, builder: (context, state) {
          final invalidValue =
              (state is CounterStateInvalidNumber) ? state.invalidValue : '';
          return Column(
            children: [
              Text('${state.value}'),
              Visibility(
                visible: state is CounterStateInvalidNumber,
                child: Text('Invalid Input: $invalidValue'),
              ),
              TextField(
                controller: _controller,
                decoration:
                    const InputDecoration(hintText: 'Enter a number here:'),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.red),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      context
                          .read<CounterBloc>()
                          .add(DecrementEvent(_controller.text));
                    },
                    child: const Text('-'),
                  ),
                  TextButton(
                    onPressed: () {
                      context
                          .read<CounterBloc>()
                          .add(IncrementEvent(_controller.text));
                    },
                    child: const Text('+'),
                  )
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });

    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
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