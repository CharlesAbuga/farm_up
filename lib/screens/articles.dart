import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/my_user/my_user_bloc.dart';
import 'package:farm_up/bloc/update_user_info/update_user_info_bloc.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class Articles extends StatefulWidget {
  const Articles({super.key});

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          titlePage: 'Profile',
        ),
      ),
      body: BlocProvider(
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
                      final myUser = state.user;
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Article Title',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              TextField(
                                controller: titleController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelText: 'Enter Title',
                                ),
                              ),
                              const Text('Content',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              TextField(
                                controller: contentController,
                                maxLines: 20,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: 'Enter Content',
                                    floatingLabelAlignment:
                                        FloatingLabelAlignment.start),
                              ),

                              // Add a button to submit the article
                              BlocProvider(
                                create: (context) => UpdateUserInfoBloc(
                                    userRepository: FirebaseUserRepository()),
                                child: BlocBuilder<UpdateUserInfoBloc,
                                    UpdateUserInfoState>(
                                  builder: (context, state) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        // Add the logic to submit the article

                                        context.read<UpdateUserInfoBloc>().add(
                                              UpdateUserInfoRequired(
                                                myUser!.copyWith(
                                                  newsArticles: [
                                                    {
                                                      'title':
                                                          titleController.text,
                                                      'content':
                                                          contentController
                                                              .text,
                                                      'date': DateTime.now()
                                                          .toString(),
                                                      'author': myUser.name,
                                                    }
                                                  ],
                                                ),
                                              ),
                                            );
                                      },
                                      child: const Text('Submit'),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
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
            return const Center(
              child: Text('You are not authenticated'),
            );
          },
        ),
      ),
    );
  }
}
