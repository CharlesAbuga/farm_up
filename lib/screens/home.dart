import 'package:farm_up/bloc/get_livestock/get_livestock_bloc.dart';
import 'package:farm_up/bloc/my_user/my_user_bloc.dart';
import 'package:farm_up/image_conv.dart';
import 'package:farm_up/screens/feeding_schedule_main.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:farm_up/widgets/home_container.dart';
import 'package:farm_up/widgets/home_container_outlined.dart';
import 'package:farm_up/widgets/home_my_farm_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:livestock_repository/livestock_repository.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<Widget> container = [
    const HomeMyFarmContainer(
        picUrl: 'assets/images/cow.svg', title: "Cows", number: '10'),
    const HomeMyFarmContainer(
        picUrl: 'assets/images/sheep.svg', title: "Sheep", number: '5'),
    const HomeMyFarmContainer(
        picUrl: 'assets/images/pig.svg', title: "Pigs", number: '3'),
    const HomeMyFarmContainer(
        picUrl: 'assets/images/goat.svg', title: "Goats", number: '2'),
    const HomeMyFarmContainer(
        picUrl: 'assets/images/duck.svg', title: "Ducks", number: '5'),
    const HomeMyFarmContainer(
        picUrl: 'assets/images/rabbit.svg', title: "Rabbits", number: '15'),
  ];
  @override
  Widget build(BuildContext context) {
    ImageConv imageConv = ImageConv();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBarWidget(titlePage: 'FarmUp')),
      body: BlocBuilder<MyUserBloc, MyUserState>(
        builder: (context, state) {
          if (state.status == MyUserStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == MyUserStatus.success) {
            print(state.user!.phone);
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome ${state.user!.name}',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Upcoming Activities',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      BlocBuilder<GetLivestockBloc, GetLivestockState>(
                        builder: (context, state) {
                          if (state is GetLivestockSuccess) {
                            final vaccinations = state.livestock
                                .where((animal) =>
                                    animal.vaccinations !=
                                    null) // Filter out animals with null vaccinations
                                .map((animal) => animal
                                    .vaccinations!) // Access the non-null vaccinations list
                                .expand((vaccinationsList) =>
                                    vaccinationsList) // Flatten the lists of vaccinations
                                .where((vaccination) => vaccination.date
                                    .isAfter(DateTime
                                        .now())) // Filter for future dates
                                .toList();

                            if (vaccinations.isEmpty) {
                              return const Text('No upcoming activities');
                            }

                            // Sort the vaccinations by date
                            //vaccinations.sort((a, b) => a.date.compareTo(b.date));

                            return SizedBox(
                              height: 100,
                              child: ListView.builder(
                                itemCount: vaccinations.length,
                                itemBuilder: (context, index) {
                                  final vaccination = vaccinations[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_month),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(DateFormat('dd-MM-yyyy')
                                            .format(vaccination.date)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(vaccination.name),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          return const Text('No upcoming activities');
                        },
                      ),
                      const Text(
                        'Your Farm',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 130,
                        child: BlocBuilder<GetLivestockBloc, GetLivestockState>(
                          builder: (context, state) {
                            if (state is GetLivestockSuccess) {
                              final uniqueAnimalTypes = state.livestock
                                  .map((animal) => animal.type)
                                  .toSet()
                                  .toList();
                              return ListView.builder(
                                  itemCount: uniqueAnimalTypes.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final animalType = uniqueAnimalTypes[index];
                                    // Filter livestock by type for count
                                    final animalCount = state.livestock
                                        .where((animal) =>
                                            animal.type == animalType)
                                        .length;
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: HomeMyFarmContainer(
                                          picUrl: imageConv
                                              .livestockImages[animalType]!,
                                          title: animalType,
                                          number: animalCount.toString()),
                                    );
                                  });
                            } else if (state is GetLivestockFailure) {
                              return const Center(
                                child: Text('Error fetching livestock'),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Quick Access',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // The Gridview showing containers for quick access
                      const HomeGridView(),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: Text('Error fetching user'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        tooltip: 'Chat with Farm assistant',
        onPressed: () {},
        child: const Icon(Icons.message),
      ),
    );
  }
}

class HomeGridView extends StatelessWidget {
  const HomeGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        GestureDetector(
          onTap: () {
            // Navigate to daily insights page
          },
          child: const HomeContainerOutlined(
              icon: Icon(Icons.auto_graph), title: 'Daily Insights'),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const FeedingScheduleMain();
            }));
          },
          child: const HomeContainer(
            icon: Icon(Icons.schedule),
            title: 'Feeding Schedule',
            imageUrl: 'assets/images/pattern.jpg',
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to feeding schedule page
          },
          child: const HomeContainer(
            icon: Icon(Icons.medication_outlined),
            title: 'Veterinary Services',
            imageUrl: 'assets/images/pattern.jpg',
          ),
        ),
      ],
    );
  }
}
