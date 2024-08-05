import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/my_user/my_user_bloc.dart';
import 'package:farm_up/screens/article_details.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class ArtclesViews extends StatelessWidget {
  const ArtclesViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBarWidget(titlePage: 'Articles')),
        body: BlocProvider(
          create: (context) =>
              AuthenticationBloc(myUserRepository: FirebaseUserRepository()),
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return BlocProvider(
                create: (context) => MyUserBloc(
                    // Create a new instance of MyUserBloc
                    myUserRepository: FirebaseUserRepository())
                  ..add(const GetMyUsers()), // Add GetMyUser event
                child: BlocBuilder<MyUserBloc, MyUserState>(
                  builder: (context, state) {
                    if (state.status == MyUserStatus.successAllUsers) {
                      final articles = [];
                      if (state.users != null) {
                        for (var user in state.users!) {
                          if (user.newsArticles != null) {
                            for (var article in user.newsArticles!) {
                              articles.add(article);
                            }
                          }
                        }
                      }
                      return Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: articles.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                                      onTap: () {},
                                      title: Text(articles[index]['title']),
                                      subtitle: Text(articles[index]['author']),
                                      trailing: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ArticleDetails(
                                              // Change this line
                                              title: articles[index]['title'],
                                              content: articles[index]
                                                  ['content'],
                                              user: articles[index]['author'],
                                            );
                                          }));
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      );
                    }
                    return SizedBox();
                  },
                ),
              );
            }
            return const Text('Not Authenticated');
          }),
        ));
  }
}
