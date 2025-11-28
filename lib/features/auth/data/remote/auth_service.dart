import 'dart:convert';
import 'dart:io';

import 'package:artcollab_mobile/core/network/api_client.dart';
import 'package:artcollab_mobile/core/storage/token_storage.dart';
import 'package:artcollab_mobile/core/storage/user_storage.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/features/auth/data/remote/user_dto.dart';
import 'package:artcollab_mobile/features/auth/data/remote/user_request.dart';

class AuthService {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;
  final UserStorage _userStorage;

  AuthService({
    ApiClient? apiClient,
    TokenStorage? tokenStorage,
    UserStorage? userStorage,
  })  : _apiClient = apiClient ?? ApiClient(),
        _tokenStorage = tokenStorage ?? TokenStorage(),
        _userStorage = userStorage ?? UserStorage();

  Future<Resource<UserDto>> signIn(String username, String password) async {
    try {
      final response = await _apiClient.post(
        'authentication/sign-in',
        SignInRequest(username: username, password: password).toMap(),
        includeAuth: false,
      );

      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final UserDto userDto = UserDto.fromJson(json);
        
        // Store token after successful authentication
        await _tokenStorage.saveToken(userDto.accessToken);
        
        // Store user information
        await _userStorage.saveUser(
          userId: userDto.id,
          username: userDto.username,
          role: userDto.role,
        );
        
        return Success(userDto);
      }
      
      // Parse error message from response
      try {
        final errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['message'] ?? errorJson['error'] ?? 
            'Usuario no válido o contraseña incorrecta';
        return Error(errorMessage);
      } catch (e) {
        return Error('Usuario no válido o contraseña incorrecta. Error: ${response.statusCode}');
      }
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
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
      final response = await _apiClient.post(
        'authentication/sign-up',
        SignUpRequest(
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
          additionalProp3: additionalProp3,
        ).toMap(),
        includeAuth: false,
      );

      if (response.statusCode == HttpStatus.created || response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final MessageDto messageDto = MessageDto.fromJson(json);
        return Success(messageDto);
      }
      
      // Parse error message from response
      try {
        final errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['message'] ?? errorJson['error'] ?? 
            'El usuario ya existe';
        return Error(errorMessage);
      } catch (e) {
        return Error('El usuario ya existe. Error: ${response.statusCode}');
      }
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }
}
