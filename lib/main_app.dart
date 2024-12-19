import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MainApp extends StatelessWidget {
  final UserRepository userRepository;
  const MainApp(
    this.userRepository, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc(myUserRepository: userRepository),
        ),
      ],
      child: const HomePage(),
    );
  }
}
