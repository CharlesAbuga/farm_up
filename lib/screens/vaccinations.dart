import 'package:farm_up/bloc/update_livestock/update_livestock_bloc.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:livestock_repository/livestock_repository.dart';

class VaccinationScreen extends StatefulWidget {
  final Livestock livestock;
  const VaccinationScreen({super.key, required this.livestock});

  @override
  State<VaccinationScreen> createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> {
  DateTime selectedDate = DateTime.now();
  TextEditingController vaccinationNameController = TextEditingController();
  TextEditingController vaccinationDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    vaccinationNameController.dispose();
    vaccinationDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          titlePage: 'Vaccinations',
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Below is the Vacinnation Schedule for - ${widget.livestock.name}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (widget.livestock.vaccinations != null)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.livestock.vaccinations!.length,
                      itemBuilder: (context, index) {
                        final vaccination =
                            widget.livestock.vaccinations![index];
                        return Stack(children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 100,
                            ),
                            child: SizedBox(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2.0,
                                // shadowColor: Theme.of(context).colorScheme.primary,
                                color: Theme.of(context).colorScheme.surface,
                                child: ListTile(
                                  leading: Tooltip(
                                    message: 'If Vaccinated, Check the box',
                                    child: BlocProvider(
                                      create: (context) => UpdateLivestockBloc(
                                          livestockRepository:
                                              FirebaseLivestockRepository())
                                        ..add(
                                            UpdateLivestock(widget.livestock)),
                                      child: BlocBuilder<UpdateLivestockBloc,
                                          UpdateLivestockState>(
                                        builder: (context, state) {
                                          return Checkbox(
                                            value: vaccination.isVaccinated,
                                            onChanged: (newBool) {
                                              setState(() {
                                                vaccination.isVaccinated =
                                                    newBool ?? false;
                                              });
                                              context
                                                  .read<UpdateLivestockBloc>()
                                                  .add(
                                                    UpdateLivestock(
                                                        widget.livestock),
                                                  );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  title: Text(vaccination.name),
                                  subtitle: Text(vaccination.description ?? ''),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${vaccination.date.day}/${vaccination.date.month}/${vaccination.date.year}',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 10,
                              right: 10,
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  height: 30,
                                  width: MediaQuery.of(context).size.width / 4,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        if (vaccination.isVaccinated ==
                                            true) ...[
                                          Colors.greenAccent,
                                          Colors.green,
                                        ] else if (vaccination.isVaccinated ==
                                                false &&
                                            vaccination.date
                                                .isAfter(DateTime.now())) ...[
                                          Colors.yellow,
                                          const Color.fromARGB(
                                              255, 188, 114, 3),
                                        ] else ...[
                                          const Color.fromARGB(
                                              255, 233, 133, 133),
                                          const Color.fromARGB(
                                              255, 244, 44, 30),
                                        ]
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      vaccination.isVaccinated == true
                                          ? 'Vaccinated'
                                          : vaccination.date
                                                  .isAfter(DateTime.now())
                                              ? 'Pending'
                                              : 'Unvaccinated',
                                      textAlign: TextAlign.center,
                                    ),
                                  ))), //Might be a problem here
                        ]);
                      },
                    ),
                  ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                  child: const Text(
                    'In this section you can add vaccinations',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                //const Text('You can also view the vaccination history'),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.4),
                        Theme.of(context).colorScheme.primary.withOpacity(0.4),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Enter the Name of Vaccination below'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: vaccinationNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Vaccination Name',
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Enter the Description of Vaccination below'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: vaccinationDescriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Description',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  iconColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  minimumSize: const Size(100, 40)),
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedDate = value;
                                    });
                                  }
                                });
                              },
                              child: Row(children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                const SizedBox(width: 10),
                                Text('Schedule Vaccination',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface)),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: BlocProvider(
                            create: (context) => UpdateLivestockBloc(
                                livestockRepository:
                                    FirebaseLivestockRepository())
                              ..add(UpdateLivestock(widget.livestock)),
                            child: BlocBuilder<UpdateLivestockBloc,
                                UpdateLivestockState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        minimumSize: const Size(100, 40)),
                                    onPressed: () {
                                      final vaccination = Vaccination(
                                          name: vaccinationNameController.text,
                                          description:
                                              vaccinationDescriptionController
                                                  .text,
                                          date: selectedDate);
                                      widget.livestock.vaccinations ??= [];
                                      widget.livestock.vaccinations!
                                          .add(vaccination);
                                      context.read<UpdateLivestockBloc>().add(
                                          UpdateLivestock(widget.livestock));

                                      vaccinationNameController.clear();
                                      vaccinationDescriptionController.clear();
                                      setState(() {});
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add),
                                        Text('Add Vaccination',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary)),
                                      ],
                                    ));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
