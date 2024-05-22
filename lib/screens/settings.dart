import 'package:farm_up/bloc/theme_bloc/theme_bloc.dart';
import 'package:farm_up/widgets/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBarWidget(titlePage: 'Settings')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SwitchListTile(
                secondary: context.read<ThemeBloc>().state == ThemeMode.dark
                    ? Icon(Icons.dark_mode)
                    : Icon(Icons.light_mode),
                title: const Text('Dark Mode'),
                value: context.read<ThemeBloc>().state == ThemeMode.dark,
                onChanged: (value) {
                  setState(() {
                    context.read<ThemeBloc>().add(ThemeChanged(value));
                  });
                },
              ),
              // Add more settings widgets here
            ],
          ),
        ));
  }
}
