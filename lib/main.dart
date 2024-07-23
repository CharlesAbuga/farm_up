import 'dart:io';

import 'package:farm_up/bloc/theme_bloc/theme_bloc.dart';
import 'package:farm_up/firebase_api.dart';
import 'package:farm_up/first_run.dart';
import 'package:farm_up/intro_screen.dart';
import 'package:farm_up/main_app.dart';
import 'package:farm_up/screens/homepage.dart';
import 'package:farm_up/simple_bloc_observer.dart';
import 'package:farm_up/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isIOS) {
    await Firebase.initializeApp();
    await FirebaseApi().initNotifications();
  }
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyA1CYG5anGSGcikqto8AN9gjNf0iP-zw5c",
      appId: "1:522828671309:android:9f58aba1bd9c605677af04",
      messagingSenderId: '522828671309',
      projectId: "farmup-52911",
    ));
    await FirebaseApi().initNotifications();
  }

  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: FirstRun().isFirstRun(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            print(' Snap shot data is : $snapshot.data');
          }
          final hasSeenIntro = snapshot.data ?? false;
          return BlocProvider(
            create: (context) => ThemeBloc(),
            child: BlocBuilder<ThemeBloc, ThemeMode>(
              builder: (context, state) {
                return MaterialApp(
                    title: 'Flutter Demo',
                    theme: lightTheme,
                    themeMode: state,
                    darkTheme: darkTheme,
                    home: MainApp(FirebaseUserRepository()) //!hasSeenIntro
                    //     ? MainApp(FirebaseUserRepository())
                    //     : const IntroScreen(),
                    );
              },
            ),
          );
        });
  }
}
