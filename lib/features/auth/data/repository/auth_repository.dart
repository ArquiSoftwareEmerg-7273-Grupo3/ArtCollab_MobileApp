import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/features/auth/data/remote/auth_service.dart';
import 'package:artcollab_mobile/features/auth/data/remote/user_dto.dart';
import 'package:artcollab_mobile/features/auth/domain/entities/reg_message.dart';
import 'package:artcollab_mobile/features/users/domain/entities/user.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<Resource<User>> signIn(String username, String password) async {
    Resource<UserDto> result = await _authService.signIn(username, password);

    if (result is Success) {
      return Success(result.data!.toUser());
    } else {
      return Error(result.message!);
    }
  }

  Future<Resource<RegMessage>> signUp(
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
    Resource<MessageDto> result = await _authService.signUp(
      username,
      password,
      ubicacion,
      nombres,
      apellidos,
      telefono,
      foto,
      descripcion,
      fechaNacimiento,
      additionalProp1,
      additionalProp2,
      additionalProp3,
    );

    if (result is Success) {
      return Success(result.data!.toMessage());
    } else {
      return Error(result.message!);
    }
  }
}
