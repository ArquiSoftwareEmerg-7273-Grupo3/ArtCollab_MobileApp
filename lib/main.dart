import 'package:artcollab_mobile/features/auth/presentation/blocs/hidden_password_cubit.dart';
import 'package:artcollab_mobile/features/auth/presentation/pages/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => HiddenPasswordCubit())
      ], 
      child: MaterialApp(
        home: const AuthScreen(),
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        theme: ThemeData.light(),
      ),
    ) ;
    
  }
}
