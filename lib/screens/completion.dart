import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/my_user/my_user_bloc.dart';
import 'package:farm_up/screens/home.dart';
import 'package:farm_up/screens/homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class CompletionScreen extends StatelessWidget {
  const CompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check_circle, size: 100, color: Colors.green)
                .animate()
                .scale(duration: Duration(seconds: 1)),
            Text('Congratulations! You have completed the Appliacation'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BlocProvider(
                    create: (context) => AuthenticationBloc(
                        myUserRepository: FirebaseUserRepository()),
                    child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) {
                        if (state.status ==
                            AuthenticationStatus.authenticated) {
                          return BlocProvider(
                            create: (context) => MyUserBloc(
                                // Create a new instance of MyUserBloc
                                myUserRepository: context
                                    .read<AuthenticationBloc>()
                                    .userRepository)
                              ..add(GetMyUser(
                                  myUserId: context
                                      .read<AuthenticationBloc>()
                                      .state
                                      .user!
                                      .uid)),
                            child: const Home(),
                          );
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  );
                }));
              },
              child: Text('Go Back'),
            )
          ],
        ),
      ),
    );
  }
}
