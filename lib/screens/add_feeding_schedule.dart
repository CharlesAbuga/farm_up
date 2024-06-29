import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class AddFeedingScreen extends StatefulWidget {
  final String animalType;
  const AddFeedingScreen({super.key, required this.animalType});

  @override
  State<AddFeedingScreen> createState() => _AddFeedingScreenState();
}

class _AddFeedingScreenState extends State<AddFeedingScreen> {
  final List<TextEditingController> feedNameControllerList = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<TimeOfDay> timeList = [];
  TextEditingController feedNameController = TextEditingController();
  bool isSubmmitted = false; // Initial height of the container
  double containerHeight = 100;
  TimeOfDay time = TimeOfDay.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addFeedingSchedule();
  }

  void addFeedingSchedule() {
    setState(() {
      feedNameControllerList.add(TextEditingController());
      timeList.add(TimeOfDay.now());
      _listKey.currentState?.insertItem(feedNameControllerList.length - 1);
    });
  }

  void removeFeedingSchedule(int index) {
    setState(() {
      var controller = feedNameControllerList.removeAt(index);
      var time = timeList.removeAt(index);
      _listKey.currentState?.removeItem(
          index,
          (context, animation) =>
              _buildanimation(animation, controller, time, context, index));
    });
  }

  @override
  void dispose() {
    // Dispose all the controllers
    for (var controller in feedNameControllerList) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Types'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Add Feeding Schedule for ${widget.animalType} below'),
              const Text(
                  'Enter the name on the textfield and the time by clicking the clock icon.'),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        addFeedingSchedule();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          CupertinoIcons.plus,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('Add another feeding schedule',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedList(
                shrinkWrap: true,
                key: _listKey,
                initialItemCount: feedNameControllerList.length,
                itemBuilder: (context, index, animation) => _buildanimation(
                    animation,
                    feedNameControllerList[index],
                    timeList[index],
                    context,
                    index),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print(
                        'Feed Name: ${feedNameControllerList.map((e) => e.text).toList()}');
                    print('Time: ${timeList}');
                  },
                  child: const Text('Save Feeding Schedule'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizeTransition _buildanimation(
      Animation<double> animation,
      TextEditingController controller,
      TimeOfDay time,
      BuildContext context,
      int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: MediaQuery.of(context).size.width * 0.9,
              height: containerHeight,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: controller,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              hintText: 'Enter feed name',
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            onSubmitted: (value) {
                              // Update the container height when enter is pressed
                              setState(() {
                                isSubmmitted = true;
                                containerHeight =
                                    115; // New height to expand the container
                              });
                            },
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
                                  isSubmmitted = true;
                                  containerHeight = 115;
                                  timeList[index] = timeOfDay;
                                });
                              }
                            },
                            iconSize: 30,
                            color: Theme.of(context).colorScheme.primary,
                            icon: const Icon(CupertinoIcons.clock_fill)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    isSubmmitted
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Feed: ${controller.text}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface)),
                              Text(' Time: ${time.format(context)}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface))
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  removeFeedingSchedule(index);
                });
              },
              child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(1, 2),
                      ),
                    ],
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: const Icon(CupertinoIcons.minus))),
            ),
          )
        ],
      ),
    );
  }
}
