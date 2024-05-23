import 'package:farm_up/bloc/sign_in/sign_in_bloc.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          titlePage: 'Profile',
        ),
      ),
      body: BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          return Center(
              child: ElevatedButton(
                  onPressed: () {
                    context.read<SignInBloc>().add(SignOutRequired());
                  },
                  child: const Text('Sign Out')));
        },
      ),
    );
  }
}
