import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/get_livestock/get_livestock_bloc.dart';
import 'package:farm_up/screens/search_livestock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:livestock_repository/livestock_repository.dart';
import 'package:user_repository/user_repository.dart';

class AppBarWidget extends StatefulWidget {
  final String titlePage;
  const AppBarWidget({super.key, required this.titlePage});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  bool _isSearching = false;
  void _navigateToSearchPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchLivestock()));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: Border(
        bottom: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
      ),
      title: AnimatedCrossFade(
        firstChild: Text(widget.titlePage,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold)),
        secondChild: BlocProvider(
          create: (context) => GetLivestockBloc(
              livestockRepository: FirebaseLivestockRepository()),
          child: TextField(
            onChanged: (text) {
              if (text.isNotEmpty) {
                _navigateToSearchPage();
              }
            },
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search in ${widget.titlePage}',
              border: InputBorder.none,
            ),
          ),
        ),
        crossFadeState:
            _isSearching ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 200),
      ),
      actions: [
        IconButton(
          icon: !_isSearching
              ? const Icon(Icons.search)
              : const Icon(Icons.cancel_outlined),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const NotificationWidget();
                });
          },
        ),
      ],
    );
  }
}

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({
    super.key,
  });

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocProvider(
        create: (context) =>
            AuthenticationBloc(myUserRepository: FirebaseUserRepository()),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return BlocProvider(
                create: (context) => GetLivestockBloc(
                    livestockRepository: FirebaseLivestockRepository())
                  ..add(GetLivestock(state.user!.uid)),
                child: BlocBuilder<GetLivestockBloc, GetLivestockState>(
                  builder: (context, state) {
                    if (state is GetLivestockLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetLivestockSuccess) {
                      var allFeedingTimes = state.livestock
                          .expand((livestock) => livestock.feedingTimes ?? [])
                          .toList();

                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allFeedingTimes.length,
                        itemBuilder: (context, index) {
                          var feedingTime = allFeedingTimes[index];
                          String formattedTime =
                              DateFormat('hh:mm a').format(feedingTime.time);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: ListTile(
                                subtitle: Row(
                                  children: [
                                    const Icon(CupertinoIcons.clock),
                                    Text(' at $formattedTime'),
                                  ],
                                ),
                                title: Text(feedingTime.feedName),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is GetLivestockFailure) {
                      return const ListTile(
                        title: Text('No notifications'),
                      );
                    }
                    return const ListTile(
                      title: Text('No notifications'),
                    );
                  },
                ),
              );
            }
            return const ListTile(
              title: Text('Please login to view notifications'),
            );
          },
        ),
      ),
    );
  }
}
