import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/google_sign_in/google_sign_in_bloc.dart';
import 'package:farm_up/bloc/sign_in/sign_in_bloc.dart';
import 'package:farm_up/bloc/sign_up/sign_up_bloc.dart';
import 'package:farm_up/screens/authentication/sign_in_screen.dart';
import 'package:farm_up/screens/authentication/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Welcome'),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Welcome to FarmUp2!'),
                    TabBar(
                        controller: tabController,
                        unselectedLabelColor: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.3),
                        labelColor: Theme.of(context).colorScheme.onSurface,
                        tabs: const [
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ]),
                    Expanded(
                      child: TabBarView(controller: tabController, children: [
                        BlocProvider<SignInBloc>(
                          create: (context) => SignInBloc(
                              userRepository: context
                                  .read<AuthenticationBloc>()
                                  .userRepository),
                          child: const SignInScreen(),
                        ),
                        MultiBlocProvider(
                          providers: [
                            BlocProvider<SignUpBloc>(
                              create: (context) => SignUpBloc(
                                  userRepository: context
                                      .read<AuthenticationBloc>()
                                      .userRepository),
                            ),
                            BlocProvider(
                              create: (context) => GoogleSignInBloc(
                                  userRepository: context
                                      .read<AuthenticationBloc>()
                                      .userRepository),
                            ),
                          ],
                          child: const SignUpScreen(),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
