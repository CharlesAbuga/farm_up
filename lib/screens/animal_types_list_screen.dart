import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/get_livestock/get_livestock_bloc.dart';
import 'package:farm_up/screens/animal_details.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livestock_repository/livestock_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_repository/user_repository.dart';

class AnimalTypesListScreen extends StatelessWidget {
  final String animalType;
  const AnimalTypesListScreen({super.key, required this.animalType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthenticationBloc(myUserRepository: FirebaseUserRepository()),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return BlocProvider(
              create: (context) => GetLivestockBloc(
                  livestockRepository: FirebaseLivestockRepository())
                ..add(
                  GetLivestock(
                      context.read<AuthenticationBloc>().state.user!.uid),
                ),
              child: Scaffold(
                  appBar: const PreferredSize(
                      preferredSize: Size.fromHeight(kToolbarHeight),
                      child: AppBarWidget(titlePage: 'Animal Types')),
                  body: BlocBuilder<GetLivestockBloc, GetLivestockState>(
                    builder: (context, state) {
                      if (state is GetLivestockLoading) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 220,
                              crossAxisCount: 2,
                            ),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    width: 200,
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          color: Colors.grey[300],
                                          child: const Text('Loading...',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          color: Colors.grey[300],
                                          child: const Text('Loading...'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      } else if (state is GetLivestockSuccess) {
                        final animalCount = state.livestock
                            .where((animal) => animal.type == animalType)
                            .toList();

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 220,
                            crossAxisCount: 2,
                          ),
                          itemCount: animalCount.length,
                          itemBuilder: (context, index) {
                            final animal = animalCount[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                        return AnimalDetails(
                                          livestockId: animal.id,
                                        );
                                      }),
                                    );
                                  },
                                  child: Container(
                                    height: 150,
                                    width: 200,
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: (animal.images != null &&
                                            animal.images!.isNotEmpty)
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                                animal.images![0],
                                                fit: BoxFit.cover),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                                'assets/images/default2.jpg',
                                                fit: BoxFit.cover),
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Name: ${animal.name}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 8),
                                      Text('Breed: ${animal.breed}'),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )),
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
