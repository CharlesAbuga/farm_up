import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/get_livestock/get_livestock_bloc.dart';
import 'package:farm_up/widgets/animal_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livestock_repository/livestock_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_repository/user_repository.dart';

class AnimalDetails extends StatefulWidget {
  final String livestockId;

  const AnimalDetails({super.key, required this.livestockId});

  @override
  State<AnimalDetails> createState() => _AnimalDetailsState();
}

class _AnimalDetailsState extends State<AnimalDetails> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Details'),
      ),
      body: BlocProvider(
        create: (context) => AuthenticationBloc(
            // Create a new instance of AuthenticationBloc
            myUserRepository: FirebaseUserRepository()),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return BlocProvider(
                create: (context) => GetLivestockBloc(
                    livestockRepository: FirebaseLivestockRepository())
                  ..add(GetLivestock(
                      context.read<AuthenticationBloc>().state.user!.uid)),
                child: BlocBuilder<GetLivestockBloc, GetLivestockState>(
                    builder: (context, state) {
                  if (state is GetLivestockSuccess) {
                    final livestock = state.livestock.firstWhere(
                      (element) => element.id == widget.livestockId,
                    );
                    //The body begins here with the livestock details
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BlocListener<GetLivestockBloc, GetLivestockState>(
                            listener: (context, state) {
                              if (state is GetLivestockLoading) {
                                SizedBox(
                                  height: 250,
                                  width: 300,
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: SizedBox(
                              height: 250,
                              width: 300,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  fadeInDuration: const Duration(seconds: 2),
                                  placeholder:
                                      'assets/images/placeholderimage.png',
                                  image: livestock.images![selectedImage],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(livestock.images!.length,
                                  (index) => smallPreview(index, livestock)),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 22.0),
                                child: Text('Animal Details',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: GridView(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisExtent: 100, crossAxisCount: 2),
                                children: [
                                  DetailCard(
                                    title: 'Name',
                                    value: livestock.name,
                                  ),
                                  DetailCard(
                                    title: 'Name',
                                    value: livestock.birthDate.toString(),
                                  ),
                                  DetailCard(
                                    title: 'Gender',
                                    value: livestock.gender,
                                  ),
                                  DetailCard(
                                    title: 'Breed',
                                    value: livestock.breed,
                                  ),
                                ]),
                          )
                        ],
                      ),
                    );
                  }
                  // Return a circular progress indicator while the data is loading
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
              );
            }
            // Return an empty center widget if the user is not authenticated
            return const Center(
              child: SizedBox(),
            );
          },
        ),
      ),
    );
  }

  GestureDetector smallPreview(int index, Livestock livestock) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(0),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color:
                  selectedImage == index ? Colors.black : Colors.transparent),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(livestock.images![index], fit: BoxFit.cover),
        ),
      ),
    );
  }
}
