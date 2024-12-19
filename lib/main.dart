import 'dart:io';

import 'package:farm_up/bloc/theme_bloc/theme_bloc.dart';
import 'package:farm_up/firebase_api.dart';
import 'package:farm_up/first_run.dart';
import 'package:farm_up/intro_screen.dart';
import 'package:farm_up/main_app.dart';
import 'package:farm_up/simple_bloc_observer.dart';
import 'package:farm_up/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  if (Platform.isIOS) {
    await Firebase.initializeApp();
    await FirebaseApi().initNotifications();
  }
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: "${dotenv.env['APIKEY_FIREBASE']}",
      appId: "${dotenv.env['APP_ID']}",
      messagingSenderId: "${dotenv.env['MESSAGE_SENDER_ID']}",
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
                  home: !hasSeenIntro
                      ? MainApp(FirebaseUserRepository())
                      : const IntroScreen(),
                );
              },
            ),
          );
        });
  }
}
