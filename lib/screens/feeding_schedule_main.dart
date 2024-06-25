import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/get_livestock/get_livestock_bloc.dart';
import 'package:farm_up/screens/add_feeding_schedule.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livestock_repository/livestock_repository.dart';
import 'package:user_repository/user_repository.dart';

class FeedingScheduleMain extends StatelessWidget {
  const FeedingScheduleMain({super.key});

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
                ..add(GetLivestock(
                    context.read<AuthenticationBloc>().state.user!.uid)),
              child: BlocBuilder<GetLivestockBloc, GetLivestockState>(
                builder: (context, state) {
                  if (state is GetLivestockSuccess) {
                    final livestock = state.livestock;
                    return Scaffold(
                      appBar: const PreferredSize(
                          preferredSize: Size.fromHeight(kToolbarHeight),
                          child: AppBarWidget(titlePage: 'Feeding Schedules')),
                      body: SingleChildScrollView(
                          child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              'Add new feeding schedule',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                                'Click add button to add a new feeding schedule to your farm.'),
                            trailing: IconButton.filled(
                              iconSize: 20,
                              hoverColor: Colors.green,
                              splashRadius: 50,
                              onPressed: () {
                                // Add new feeding schedule
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialogList(
                                        livestock: livestock);
                                  },
                                );
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ),
                          // Add list of feeding schedules here
                        ],
                      )),
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

class AlertDialogList extends StatelessWidget {
  const AlertDialogList({
    super.key,
    required this.livestock,
  });

  final List<Livestock> livestock;

  @override
  Widget build(BuildContext context) {
    final uniqueAnimalTypes = livestock.map((e) => e.type).toSet();
    return AlertDialog(
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      title: const Text('Create Feeding Schedule for:'),
      content: SizedBox(
        // Set a fixed height for the horizontal list

        width: double.maxFinite,
        height: 300,
        child: Scrollbar(
          thickness: 6,
          radius: const Radius.circular(10),
          thumbVisibility: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: uniqueAnimalTypes.length,
              itemBuilder: (BuildContext context, int index) {
                final animal = livestock[index];
                final animalType = uniqueAnimalTypes.elementAt(index);
                return InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    // Add new feeding schedule
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddFeedingScreen(
                          animalType: animalType,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Theme.of(context).colorScheme.primary,
                    child: SizedBox(
                      width: 160.0, // Fixed width for each item
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(animalType), // Display the animal's name
                          // Add more details as needed
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}
