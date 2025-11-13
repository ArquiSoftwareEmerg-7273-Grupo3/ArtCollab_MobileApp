import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/features/auth/data/remote/auth_service.dart';
import 'package:artcollab_mobile/features/auth/data/remote/user_dto.dart';
import 'package:artcollab_mobile/features/auth/domain/entities/reg_message.dart';
import 'package:artcollab_mobile/features/users/domain/entities/user.dart';


class AuthRepository {
  Future<Resource<User>> signIn(String username, String password) async {
    Resource<UserDto> result = await AuthService().signIn(username, password);

    if (result is Success) {
      return Success(result.data!.toUser());
    } else {
      return Error(result.message!);
    }
  }

  // Modificar
  Future<Resource<RegMessage>> signUp(String username, String password) async {
    Resource<MessageDto> result = await AuthService().signUp(username, password);

    if (result is Success) {
      return Success(result.data!.toMessage());
    } else {
      return Error(result.message!);
    }
  }
}
