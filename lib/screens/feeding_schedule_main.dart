import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/material.dart';

class FeedingScheduleMain extends StatelessWidget {
  const FeedingScheduleMain({super.key});

  @override
  Widget build(BuildContext context) {
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
              },
              icon: const Icon(Icons.add),
            ),
          ),
          // Add list of feeding schedules here
        ],
      )),
    );
  }
}
