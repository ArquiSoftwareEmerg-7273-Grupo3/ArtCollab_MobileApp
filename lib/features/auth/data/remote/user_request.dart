class SignInRequest {
  final String username;
  final String password;

  const SignInRequest({required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return {'username': username, 'password': password};
  }
}

class SignUpRequest {
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

  const SignUpRequest({
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

  Map<String, dynamic> toMap() {
    return {
      'username': username, 
      'password': password,
      'ubicacion': ubicacion,
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono,
      'foto': foto,
      'descripcion': descripcion,
      'fechaNacimiento': fechaNacimiento,
      "redesSociales": {
        "additionalProp1": additionalProp1,
        "additionalProp2": additionalProp2,
        "additionalProp3": additionalProp3
      }
    };
  }
}