import 'package:farm_up/bloc/update_livestock/update_livestock_bloc.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livestock_repository/livestock_repository.dart';
import 'package:intl/intl.dart';

class ViewFeedingScreen extends StatefulWidget {
  final String animalType;
  final Livestock livestock;
  const ViewFeedingScreen(
      {super.key, required this.animalType, required this.livestock});

  @override
  State<ViewFeedingScreen> createState() => _ViewFeedingScreenState();
}

class _ViewFeedingScreenState extends State<ViewFeedingScreen> {
  String _selectedView = 'ListView';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBarWidget(titlePage: 'View Schedule')),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('Feeding Schedule'),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(20),
                          value: _selectedView,
                          icon: SizedBox(),
                          onChanged: (String? newValue) {
                            // Handle dropdown value change
                            setState(() {
                              _selectedView = newValue!;
                            });
                          },
                          items: <String>['ListView', 'GridView']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AnimatedSwitcher(
                duration: const Duration(
                    milliseconds:
                        500), // Adjust the duration to suit your needs
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(
                            0, 0.5), // Adjust the starting position as needed
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _selectedView == 'ListView'
                    ? ListViewMode(
                        key: const ValueKey('ListView'),
                        animalType: widget.animalType,
                        livestock: widget.livestock) // Assign a unique key
                    : TableMode(
                        key: const ValueKey('Table'),
                        livestock: widget.livestock), // Assign a unique key
              ),
            ],
          ),
        )));
  }
}

class ListViewMode extends StatefulWidget {
  const ListViewMode({
    super.key,
    required this.livestock,
    required this.animalType,
  });

  final Livestock livestock;
  final String animalType;

  @override
  State<ListViewMode> createState() => _ListViewModeState();
}

class _ListViewModeState extends State<ListViewMode> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateLivestockBloc(
          livestockRepository: FirebaseLivestockRepository()),
      child: BlocConsumer<UpdateLivestockBloc, UpdateLivestockState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is UpdateLivestockSuccess) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.livestock.feedingTimes!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  surfaceTintColor: Theme.of(context).colorScheme.secondary,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            ' Feed Name: ${widget.livestock.feedingTimes![index].feedName}'),
                        IconButton.filled(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Edit Details'),
                                    content: SetupDialogContent(
                                      livestock: widget.livestock,
                                      animalType: widget.animalType,
                                      feedingTimes:
                                          widget.livestock.feedingTimes![index],
                                    ), // Step 2: Create a separate widget for dialog content
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit)),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            ' Time: ${DateFormat('h:mm a').format(widget.livestock.feedingTimes![index].time)}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.livestock.feedingTimes!.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                surfaceTintColor: Theme.of(context).colorScheme.secondary,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          ' Feed Name: ${widget.livestock.feedingTimes![index].feedName}'),
                      IconButton.filled(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Edit Details'),
                                  content: SetupDialogContent(
                                    livestock: widget.livestock,
                                    animalType: widget.animalType,
                                    feedingTimes:
                                        widget.livestock.feedingTimes![index],
                                  ), // Step 2: Create a separate widget for dialog content
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.edit)),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          ' Time: ${DateFormat('h:mm a').format(widget.livestock.feedingTimes![index].time)}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TableMode extends StatelessWidget {
  const TableMode({
    super.key,
    required this.livestock,
  });
  final Livestock livestock;
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
          borderRadius: BorderRadius.circular(10)),
      children: [
        TableRow(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
          children: const [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Feed Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Time',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Edit',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        for (var feedingTime in livestock.feedingTimes!)
          TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(feedingTime.feedName),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat('h:mm a').format(feedingTime.time),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class SetupDialogContent extends StatefulWidget {
  final FeedingTime feedingTimes;
  final Livestock livestock;
  final String animalType;
  const SetupDialogContent(
      {super.key,
      required this.feedingTimes,
      required this.livestock,
      required this.animalType});
  @override
  State<SetupDialogContent> createState() => _SetupDialogContentState();
}

class _SetupDialogContentState extends State<SetupDialogContent> {
  final _nameController = TextEditingController();
  final _timeController = TextEditingController();
  TimeOfDay time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize:
          MainAxisSize.min, // To make the dialog content size wrap its content
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'Feed Name'),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                controller: _timeController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Time'),
              ),
            ),
            IconButton(
                onPressed: () async {
                  final TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: time,
                  );
                  if (timeOfDay != null) {
                    setState(() {
                      time = timeOfDay;
                      _timeController.text = timeOfDay.format(context);
                    });
                  }
                },
                iconSize: 30,
                color: Theme.of(context).colorScheme.primary,
                icon: const Icon(CupertinoIcons.clock_fill)),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        BlocProvider(
          create: (context) => UpdateLivestockBloc(
              livestockRepository: FirebaseLivestockRepository()),
          child: BlocBuilder<UpdateLivestockBloc, UpdateLivestockState>(
            builder: (context, state) {
              return ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  backgroundColor: WidgetStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary),
                ),
                onPressed: () {
                  final Livestock currentLivestock = widget.livestock;
                  final String currentAnimalType = widget.animalType;
                  // Step 3: Handle Form Submission
                  final String name = _nameController.text;

                  final DateTime time = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      this.time.hour,
                      this.time.minute);

                  int indexToEdit = currentLivestock.feedingTimes!
                      .indexOf(widget.feedingTimes);
                  if (indexToEdit != -1) {
                    // Create a new FeedingTime with the updated information
                    final FeedingTime updatedFeedingTime = widget.feedingTimes
                        .copyWith(feedName: name, time: time);

                    // Update the list by replacing the old FeedingTime with the new one
                    currentLivestock.feedingTimes![indexToEdit] =
                        updatedFeedingTime;

                    // Now, update the livestock with the modified feeding times list
                    context
                        .read<UpdateLivestockBloc>()
                        .add(UpdateLivestock(currentLivestock));
                  }

                  Navigator.pop(context);
                  setState(() {});

                  // final FeedingTime feedingTime =
                  //     widget.feedingTimes.copyWith(feedName: name, time: time);

                  // final List<FeedingTime> updatedFeedingTimes =
                  //     currentLivestock.feedingTimes!;
                  // updatedFeedingTimes.add(feedingTime);

                  // context
                  //     .read<UpdateLivestockBloc>()
                  //     .add(UpdateLivestock(currentLivestock));
                },
                child: Text('Update',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surface)),
              );
            },
          ),
        ),
      ],
    );
  }
}
