import 'package:flutter_bloc/flutter_bloc.dart';

class HiddenPasswordCubit extends Cubit<bool> {
  HiddenPasswordCubit() : super(true);

  void changeVisibility(){
    emit(!state);
  }
}