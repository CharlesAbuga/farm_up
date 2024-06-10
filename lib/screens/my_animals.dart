import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/create_livestock/create_livestock_bloc.dart';
import 'package:farm_up/bloc/get_livestock/get_livestock_bloc.dart';
import 'package:farm_up/bloc/my_user/my_user_bloc.dart';
import 'package:farm_up/screens/add_livestock_screen.dart';
import 'package:farm_up/screens/animal_types_list_screen.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livestock_repository/livestock_repository.dart';

class MyAnimalsScreen extends StatelessWidget {
  const MyAnimalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              const ListTile(
                title: const Text(
                  'Your Animals are:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              BlocBuilder<GetLivestockBloc, GetLivestockState>(
                builder: (context, state) {
                  if (state is GetLivestockSuccess) {
                    final uniqueAnimalTypes = state.livestock
                        .map((animal) => animal.type)
                        .toSet()
                        .toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: uniqueAnimalTypes.length,
                      itemBuilder: (context, index) {
                        final animalType = uniqueAnimalTypes[index];
                        // Filter livestock by type for count
                        final animalCount = state.livestock
                            .where((animal) => animal.type == animalType)
                            .length;
                        return ListTile(
                          subtitle: Text(animalCount.toString()),
                          title: Text(animalType),
                          trailing: BlocProvider(
                            create: (context) => GetLivestockBloc(
                                livestockRepository:
                                    FirebaseLivestockRepository())
                              ..add(GetLivestock(context
                                  .read<AuthenticationBloc>()
                                  .state
                                  .user!
                                  .uid)),
                            child: IconButton.filled(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AnimalTypesListScreen(
                                          animalType: animalType,
                                        )));
                              },
                              icon: const Icon(
                                  size: 15, CupertinoIcons.arrow_right),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is GetLivestockFailure) {
                    return const Center(
                      child: Text('Error fetching livestock'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ));
  }
}
