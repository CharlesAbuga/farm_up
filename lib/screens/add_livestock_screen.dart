import 'dart:io';

import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/create_livestock/create_livestock_bloc.dart';
import 'package:farm_up/bloc/my_user/my_user_bloc.dart';
import 'package:farm_up/bloc/update_user_info/update_user_info_bloc.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livestock_repository/livestock_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class AddLivestock extends StatefulWidget {
  const AddLivestock({super.key});

  @override
  State<AddLivestock> createState() => _AddLivestockState();
}

class _AddLivestockState extends State<AddLivestock> {
  late Livestock livestock;
  String selectedAnimalType = 'Cow';
  TextEditingController nameController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  String selectedGender = 'Male'; // Default value for gender
  DateTime selectedDate = DateTime.now();
  List<File>? selectedImages;
  List<String> urlsToUpload = [];
  Future pickImage() async {
    // Code to pick an image from the gallery
    try {
      final List<XFile> pickedImages = await ImagePicker().pickMultiImage();

      setState(() {
        selectedImages = pickedImages.map((file) => File(file.path)).toList();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBarWidget(titlePage: 'Add Livestock')),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: BlocProvider(
            create: (context) => AuthenticationBloc(
              // Create a new instance of AuthenticationBloc
              myUserRepository: FirebaseUserRepository(),
            ),
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state.status == AuthenticationStatus.unauthenticated) {
                  return const Center(
                    child: Text('Please sign in to add a new user'),
                  );
                }
                if (state.status == AuthenticationStatus.authenticated) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => UpdateUserInfoBloc(
                          userRepository:
                              context.read<AuthenticationBloc>().userRepository,
                        ),
                      ),
                      BlocProvider(
                        create: (context) => CreateLivestockBloc(
                          // Create a new instance of CreateLivestockBloc
                          livestockRepository: FirebaseLivestockRepository(),
                        ),
                      ),
                      BlocProvider(
                          create: (context) => MyUserBloc(
                                // Create a new instance of MyUserBloc
                                myUserRepository: context
                                    .read<AuthenticationBloc>()
                                    .userRepository,
                              )..add(
                                  GetMyUser(
                                      myUserId: context
                                          .read<AuthenticationBloc>()
                                          .state
                                          .user!
                                          .uid),
                                )),
                    ],
                    child: BlocBuilder<MyUserBloc, MyUserState>(
                      builder: (context, state) {
                        return BlocBuilder<CreateLivestockBloc,
                            CreateLivestockState>(
                          builder: (context, state) {
                            return SingleChildScrollView(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                          'Please enter the details below to add a new animal to your farm.'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                          '1. Please add the Animal type below'),
                                      //Below is the code for Animal Type
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14.0),
                                        child: DropdownButton<String>(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          value: selectedAnimalType,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedAnimalType = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            'Cow',
                                            'Sheep',
                                            'Goat',
                                            'Pig',
                                            'Duck',
                                            'Rabbit',
                                            'Chicken',
                                            'Horse',
                                            'Turkey'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .tertiary,
                                                iconColor: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                minimumSize:
                                                    const Size(100, 40)),
                                            onPressed: () {
                                              showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime.now(),
                                              ).then((value) {
                                                if (value != null) {
                                                  setState(() {
                                                    selectedDate = value;
                                                  });
                                                }
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(
                                                    Icons.calendar_today),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text('Select Date',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface)),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Text('3. Enter Name'),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          )),
                                          labelText:
                                              'Enter the name of the animal',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Text('4. Enter breed'),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextField(
                                        controller: breedController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          )),
                                          labelText:
                                              'Enter the breed of the animal',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Text('5. Enter Gender'),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14.0),
                                        child: DropdownButton<String>(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          value: selectedGender,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedGender = newValue!;
                                            });
                                          },
                                          items: <String>['Male', 'Female']
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Text('6. Add Images'),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              surfaceTintColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              minimumSize: const Size(200, 40)),
                                          onPressed: () {
                                            pickImage();
                                          },
                                          child: Text('Click to add Images',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface))),
                                      selectedImages != null
                                          ? SizedBox(
                                              height: 200,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      selectedImages!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Image.file(
                                                      selectedImages![index],
                                                      height: 150,
                                                      width: 150,
                                                    );
                                                  }),
                                            )
                                          : const Text(
                                              'No image selected',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 112, 103, 18)),
                                            ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Center(
                                        child: BlocBuilder<UpdateUserInfoBloc,
                                            UpdateUserInfoState>(
                                          builder: (context, state) {
                                            return ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  surfaceTintColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  minimumSize: const Size(
                                                      double.infinity, 40)),
                                              onPressed: () async {
                                                print(
                                                    selectedImages.toString());
                                                setState(() {});
                                                try {
                                                  final storage = FirebaseStorage
                                                      .instanceFor(
                                                          bucket:
                                                              'gs://farmup-52911.appspot.com');
                                                  for (final image
                                                      in selectedImages!) {
                                                    final imageRef = storage
                                                        .ref()
                                                        .child(
                                                            'userImages/${DateTime.now()}');
                                                    final uploadTask =
                                                        imageRef.putFile(image);

                                                    final snapshot =
                                                        await uploadTask
                                                            .whenComplete(
                                                                () => null);
                                                    final urlsDownload =
                                                        await snapshot.ref
                                                            .getDownloadURL();
                                                    urlsToUpload
                                                        .add(urlsDownload);
                                                  }

                                                  livestock = Livestock(
                                                    id: const Uuid().v1(),
                                                    userId: context
                                                        .read<MyUserBloc>()
                                                        .state
                                                        .user!
                                                        .id,
                                                    gender: selectedGender,
                                                    type: selectedAnimalType,
                                                    birthDate: selectedDate,
                                                    name: nameController.text,
                                                    breed: breedController.text,
                                                    images: urlsToUpload,
                                                  );
                                                  context
                                                      .read<
                                                          CreateLivestockBloc>()
                                                      .add(CreateLivestock(
                                                          livestock));
                                                  context
                                                      .read<
                                                          UpdateUserInfoBloc>()
                                                      .add(UpdateUserInfoRequired(context
                                                          .read<MyUserBloc>()
                                                          .state
                                                          .user!
                                                          .copyWith(
                                                              livestock: context
                                                                  .read<
                                                                      MyUserBloc>()
                                                                  .state
                                                                  .user!
                                                                  .livestock!
                                                                ..add(livestock
                                                                    .toEntity()
                                                                    .toDocument()))));

                                                  final SnackBar snackBar =
                                                      const SnackBar(
                                                    content: Text(
                                                        'Animal added successfully'),
                                                  );
                                                  final snackbarController =
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                  snackbarController.closed
                                                      .then((onValue) {
                                                    // Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  });
                                                } catch (e) {
                                                  print(e.toString());
                                                }
                                              },
                                              child: Text(
                                                'Add Animal',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return const Text('Something went wrong');
              },
            ),
          ),
        ));
  }
}
