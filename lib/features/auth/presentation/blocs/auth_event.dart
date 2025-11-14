abstract class AuthEvent {}

class AuthorizeUser extends AuthEvent {
  String user;
  String password;

  AuthorizeUser({required this.user, required this.password});
}

// Modificar
class RegisterUser extends AuthEvent {
  final String username;
  final String password;
  final String ubicacion;
  final String nombres;
  final String apellidos;
  final String telefono;
  final String foto;
  final String descripcion;
  final String fechaNacimiento;
  final String additionalProp1;
  final String additionalProp2;
  final String additionalProp3;  

  RegisterUser({
    required this.username, 
    required this.password, 
    required this.ubicacion, 
    required this.nombres, 
    required this.apellidos, 
    required this.telefono, 
    required this.foto, 
    required this.descripcion, 
    required this.fechaNacimiento, 
    required this.additionalProp1, 
    required this.additionalProp2, 
    required this.additionalProp3
    });
}