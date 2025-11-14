import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/features/auth/data/repository/auth_repository.dart';
import 'package:artcollab_mobile/features/auth/domain/entities/reg_message.dart';
import 'package:artcollab_mobile/features/auth/presentation/blocs/auth_event.dart';
import 'package:artcollab_mobile/features/auth/presentation/blocs/auth_state.dart';
import 'package:artcollab_mobile/features/users/domain/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<AuthorizeUser>(
      (event, emit) async {
        emit(AuthLoadingState());
        Resource<User> result =
            await AuthRepository().signIn(event.user, event.password);

        if (result is Success) {
          emit(AuthLoadedState(user: result.data!));
        } else {
          emit(AuthErrorState(message: result.message!));
        }
      },
    );

    // Modificar
    on<RegisterUser>(
      (event, emit) async {
        emit(AuthLoadingState());
        Resource<RegMessage> result = await AuthRepository().signUp(
            event.username,
            event.password,
            event.ubicacion,
            event.nombres,
            event.apellidos,
            event.telefono,
            event.foto,
            event.descripcion,
            event.fechaNacimiento,
            event.additionalProp1,
            event.additionalProp2,
            event.additionalProp3
          );

        if (result is Success) {
          emit(RegisterSuccess(regMessage: result.data!));
        } else {
          emit(AuthErrorState(message: result.message!));
        }
      },
    );
  }
}
