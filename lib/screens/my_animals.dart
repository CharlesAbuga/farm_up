import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/create_livestock/create_livestock_bloc.dart';
import 'package:farm_up/bloc/my_user/my_user_bloc.dart';
import 'package:farm_up/screens/add_livestock_screen.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livestock_repository/livestock_repository.dart';

class MyAnimalsScreen extends StatelessWidget {
  const MyAnimalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBarWidget(titlePage: 'My Animals')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                  title: const Text(
                    'Add new animal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                      'Click add button to add a new animal to your farm.'),
                  trailing: MultiBlocProvider(
                    providers: [
                      BlocProvider(
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
                      ),
                      BlocProvider(
                        create: (context) => CreateLivestockBloc(
                          // Create a new instance of CreateLivestockBloc
                          livestockRepository: FirebaseLivestockRepository(),
                        ),
                      ),
                    ],
                    child: IconButton.filled(
                      iconSize: 20,
                      hoverColor: Colors.green,
                      splashRadius: 50,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddLivestock()));
                      },
                      icon: const Icon(Icons.add),
                    ),
                  )),
            ],
          ),
        ));
  }
}
