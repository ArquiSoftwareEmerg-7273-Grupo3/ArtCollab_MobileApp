import 'dart:convert';
import 'dart:io';

import 'package:artcollab_mobile/core/constants/app_constants.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/features/auth/data/remote/user_dto.dart';
import 'package:artcollab_mobile/features/auth/data/remote/user_request.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String _signIn = '${AppConstants.authBaseUrl}authentication/sign-in';
  final String _signUp = '${AppConstants.authBaseUrl}authentication/sign-up';

  Future<Resource<UserDto>> signIn(String username, String password) async {
    try {
      http.Response response = await http.post(
        Uri.parse(_signIn),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            SignInRequest(username: username, password: password).toMap()),
      );

      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final UserDto userDto = UserDto.fromJson(json);
        return Success(userDto);
      }
      return Error(
          'Usuario no válido o contraseña incorrecta. Error: ${response.statusCode}');
    } catch (error) {
      return Error('No se pudo iniciar sesión. Error: ${error.toString()}');
    }
  }

  Future<Resource<MessageDto>> signUp(
      String username,
      String password,
      String ubicacion,
      String nombres,
      String apellidos,
      String telefono,
      String foto,
      String descripcion,
      String fechaNacimiento,
      String additionalProp1,
      String additionalProp2,
      String additionalProp3) async {
    try {
      http.Response response = await http.post(
        Uri.parse(_signUp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(SignUpRequest(
                username: username,
                password: password,
                ubicacion: ubicacion,
                nombres: nombres,
                apellidos: apellidos,
                telefono: telefono,
                foto: foto,
                descripcion: descripcion,
                fechaNacimiento: fechaNacimiento,
                additionalProp1: additionalProp1,
                additionalProp2: additionalProp2,
                additionalProp3: additionalProp3)
            .toMap()),
      );

      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final MessageDto messageDto = MessageDto.fromJson(json);
        return Success(messageDto);
      }
      return Error('El usuario ya existe. Error: ${response.statusCode}');
    } catch (error) {
      return Error('No se pudo crear la cuenta. Error: ${error.toString()}');
    }
  }
}
