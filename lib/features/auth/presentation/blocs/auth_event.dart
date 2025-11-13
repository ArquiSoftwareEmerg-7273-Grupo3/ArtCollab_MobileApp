abstract class AuthEvent {}

class AuthorizeUser extends AuthEvent {
  String user;
  String password;

  AuthorizeUser({required this.user, required this.password});
}

// Modificar
class RegisterUser extends AuthEvent {
  final String user;
  final String password;

  RegisterUser({required this.user, required this.password});
}