import 'dart:io';

import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/my_user/my_user_bloc.dart';
import 'package:farm_up/bloc/update_user_info/update_user_info_bloc.dart';
import 'package:farm_up/counties.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class VetApply extends StatefulWidget {
  VetApply({super.key, required this.user, required this.state});
  MyUser user;
  MyUserState state;

  @override
  State<VetApply> createState() => _VetApplyState();
}

class _VetApplyState extends State<VetApply> {
  int currentStep = 0;
  Future pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Step> getSteps() => [
          Step(
              state: currentStep == 0 ? StepState.indexed : StepState.complete,
              isActive: currentStep >= 0,
              title: Text('Basic Information'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: 'ID Number'),
                    ),
                    ListTile(
                      title: const Text('County'),
                      subtitle: widget.user.county == null
                          ? const Text('County not provided')
                          : Text(widget.user.county!),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialogCountyEdit(
                              context, widget.state, widget.user);
                        },
                      ),
                    ),
                  ],
                ),
              )),
          Step(
              state: currentStep == 1 ? StepState.indexed : StepState.complete,
              isActive: currentStep >= 1,
              title: Text('Required Documents'),
              content: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          pickFile();
                        },
                        child: const Text('Upload ID'),
                      ),
                      const SizedBox(width: 10),
                      const Text('No file selected')
                    ],
                  ),
                ],
              )),
          Step(
              isActive: currentStep >= 2,
              title: Text('Complete'),
              content: Container()),
        ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Vet Apply'),
      ),
      body: BlocProvider(
        create: (context) =>
            AuthenticationBloc(myUserRepository: FirebaseUserRepository()),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return BlocProvider(
                create: (context) =>
                    MyUserBloc(myUserRepository: FirebaseUserRepository())
                      ..add(GetMyUser(myUserId: state.user!.uid)),
                child: BlocBuilder<MyUserBloc, MyUserState>(
                  builder: (context, state) {
                    if (state.status == MyUserStatus.success) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                child: const Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Column(
                                    children: [
                                      ListTile(
                                          leading: const Icon(
                                            Icons.medical_services,
                                            color: Colors.white,
                                          ),
                                          title: Text(
                                            'Veterinary Application',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Apply to be a vet by entering the following details and uploading the required documents',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Stepper(
                                steps: getSteps(),
                                currentStep: currentStep,
                                onStepContinue: () {
                                  final isLastStep =
                                      currentStep == getSteps().length - 1;
                                  if (isLastStep) {
                                    print('Submit');
                                  } else {
                                    setState(() {
                                      currentStep += 1;
                                    });
                                  }
                                },
                                controlsBuilder: (BuildContext context,
                                    ControlsDetails details) {
                                  final isLastStep =
                                      currentStep == getSteps().length - 1;
                                  return Container(
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 2,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          onPressed: details.onStepContinue,
                                          child: isLastStep
                                              ? Text('Complete')
                                              : Text('Next'),
                                        ),
                                        const SizedBox(width: 10),
                                        if (currentStep != 0)
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 2,
                                            ),
                                            onPressed: details.onStepCancel,
                                            child: Text('Back',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary)),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                                onStepTapped: (step) {
                                  setState(() {
                                    currentStep = step;
                                  });
                                },
                                onStepCancel: currentStep == 0
                                    ? null
                                    : () => setState(() {
                                          currentStep -= 1;
                                        }),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              );
            }
            return const Center(child: SizedBox());
          },
        ),
      ),
    );
  }

  Future<dynamic> showDialogCountyEdit(
      BuildContext context, MyUserState state, MyUser user) {
    final List<String> counties = KenyanCounties().counties
      ..sort((a, b) => a.compareTo(b));
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select County'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return BlocProvider(
                create: (context) =>
                    UpdateUserInfoBloc(userRepository: FirebaseUserRepository())
                      ..add(UpdateUserInfoRequired(state.user!)),
                child: BlocBuilder<UpdateUserInfoBloc, UpdateUserInfoState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: user.county ?? 'Select County',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          value: user.county,
                          items: counties
                              .asMap()
                              .entries
                              .map<DropdownMenuItem<String>>((entry) {
                            final value = entry.value;
                            int index = entry.key + 1;
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text('$index. $value'),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              context.read<UpdateUserInfoBloc>().add(
                                    UpdateUserInfoRequired(
                                      user.copyWith(county: value),
                                    ),
                                  );
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            surfaceTintColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // Save the selected county
                            // You can add your own logic here
                            Navigator.pop(context);
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.exit_to_app),
                              Text('Exit'),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
