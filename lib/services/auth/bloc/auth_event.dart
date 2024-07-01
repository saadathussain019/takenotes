//imports
import 'package:flutter/foundation.dart' show immutable;

//abstract class for all AuthEvents
@immutable
abstract class AuthEvent {
  const AuthEvent();
}

//Firebase Initialization class
class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

//AuthEvent User Login requires email password
class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
