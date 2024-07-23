import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/my_user/my_user_bloc.dart';
import 'package:farm_up/bloc/sign_in/sign_in_bloc.dart';
import 'package:farm_up/bloc/update_user_info/update_user_info_bloc.dart';
import 'package:farm_up/counties.dart';
import 'package:farm_up/screens/vet_apply.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController contactController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
                    return Scaffold(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      appBar: const PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: AppBarWidget(
                          titlePage: 'Profile',
                        ),
                      ),
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.person,
                                size: 50,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(state.user!.email)),
                            const SizedBox(height: 10),
                            ListView(
                              shrinkWrap: true,
                              children: [
                                ListTile(
                                  title: const Text(
                                    'Name',
                                  ),
                                  subtitle: Text(state.user!.name),
                                ),
                                ListTile(
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showDialogPhoneEdit(context, state,
                                          state.user!, contactController);
                                    },
                                  ),
                                  title: const Text('Phone'),
                                  subtitle: Text(state.user!.phone == null
                                      ? 'Number not provided'
                                      : state.user!.phone.toString()),
                                ),
                                ListTile(
                                  title: const Text('County'),
                                  subtitle: state.user!.county == null
                                      ? const Text('County not provided')
                                      : Text(state.user!.county!),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showDialogCountyEdit(
                                          context, state, state.user!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.95,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 16.0),
                                            child: Text(
                                              'Are you a Veterinary Doctor?',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Click the Button to Apply',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface),
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VetApply(
                                                                user:
                                                                    state.user!,
                                                                state: state)));
                                              },
                                              child: Text(
                                                'Apply',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                            BlocBuilder<SignInBloc, SignInState>(
                              builder: (context, state) {
                                return Center(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<SignInBloc>()
                                              .add(SignOutRequired());
                                        },
                                        child: const Text('Sign Out')));
                              },
                            ),
                          ],
                        ),
                      ),
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

  Future<dynamic> showDialogPhoneEdit(BuildContext context, MyUserState state,
      MyUser user, TextEditingController phoneController) {
    return showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) =>
              UpdateUserInfoBloc(userRepository: FirebaseUserRepository())
                ..add(UpdateUserInfoRequired(state.user!)),
          child: BlocBuilder<UpdateUserInfoBloc, UpdateUserInfoState>(
            builder: (context, state) {
              return AlertDialog(
                title: const Text('Edit Contact Number'),
                content: TextField(
                  controller: phoneController,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<UpdateUserInfoBloc>().add(
                            UpdateUserInfoRequired(user.copyWith(
                                phone: contactController.text.isEmpty
                                    ? null
                                    : int.parse(contactController.text))),
                          );

                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
