import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/my_user/my_user_bloc.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_repository/user_repository.dart';

class VetScreen extends StatelessWidget {
  const VetScreen({super.key});

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
                    ..add(const GetMyUsers()), // Fetch all users here
              child: BlocBuilder<MyUserBloc, MyUserState>(
                builder: (context, state) {
                  if (state.status == MyUserStatus.loading) {
                    return const Scaffold(
                      appBar: PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: AppBarWidget(titlePage: 'Vet Finder'),
                      ),
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state.status == MyUserStatus.successAllUsers) {
                    final vetUsers = state.users
                            ?.where((user) => user.isVet == true)
                            .toList() ??
                        [];
                    return Scaffold(
                      appBar: const PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: AppBarWidget(titlePage: 'Vet Finder'),
                      ),
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Below is a list of all the vets registered in our database',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: vetUsers.length,
                            itemBuilder: (context, index) {
                              final user = vetUsers[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.primary,
                                        Theme.of(context).colorScheme.secondary,
                                      ], // Adjust the colors as needed
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor, // Background color of the inner container
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    margin: const EdgeInsets.all(2.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 30,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name: ${user.name}',
                                              ),
                                              Text(
                                                'Email: ${user.email}',
                                              ),
                                              Text(
                                                'Phone: +254 ${user.phone.toString()}',
                                              ),
                                              Text(
                                                'County: ${user.county}',
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.45),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          // Implement the call functionality here
                                                          final Uri
                                                              phoneLaunchUri =
                                                              Uri(
                                                            scheme: 'tel',
                                                            path:
                                                                '+254${user.phone}',
                                                          );
                                                          if (await canLaunchUrl(
                                                              phoneLaunchUri)) {
                                                            await launchUrl(
                                                                phoneLaunchUri);
                                                          } else {
                                                            throw 'Could not launch ${phoneLaunchUri.toString()}';
                                                          }
                                                        },
                                                        child: const Row(
                                                          children: [
                                                            Icon(Icons.call),
                                                            SizedBox(width: 5),
                                                            Text('Call'),
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else if (state.status == MyUserStatus.failure) {
                    return const Scaffold(
                      appBar: PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: AppBarWidget(titlePage: 'Vet Finder'),
                      ),
                      body: Center(child: Text('Failed to load users')),
                    );
                  }
                  return const SizedBox();
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
