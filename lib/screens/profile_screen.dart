import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/my_user/my_user_bloc.dart';
import 'package:farm_up/bloc/sign_in/sign_in_bloc.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthenticationBloc(myUserRepository: FirebaseUserRepository()),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return BlocProvider(
              create: (context) =>
                  MyUserBloc(myUserRepository: FirebaseUserRepository())
                    ..add(GetMyUser(myUserId: state.user!.uid)),
              child: BlocBuilder<MyUserBloc, MyUserState>(
                builder: (context, state) {
                  if (state.status == MyUserStatus.success) {
                    return Scaffold(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      appBar: const PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: AppBarWidget(
                          titlePage: 'Profile',
                        ),
                      ),
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.person,
                                size: 50,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(state.user!.email)),
                            const SizedBox(height: 10),
                            ListView(
                              shrinkWrap: true,
                              children: [
                                ListTile(
                                  title: const Text(
                                    'Name',
                                  ),
                                  subtitle: Text(state.user!.name),
                                ),
                                ListTile(
                                  title: const Text('Phone'),
                                  subtitle: Text('phone'),
                                ),
                                ListTile(
                                  title: const Text('Address'),
                                  subtitle: Text('Address'),
                                ),
                              ],
                            ),
                            BlocBuilder<SignInBloc, SignInState>(
                              builder: (context, state) {
                                return Center(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<SignInBloc>()
                                              .add(SignOutRequired());
                                        },
                                        child: const Text('Sign Out')));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: SizedBox(),
                  );
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
