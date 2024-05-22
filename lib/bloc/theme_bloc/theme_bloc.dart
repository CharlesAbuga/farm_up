import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {
    on<ThemeChanged>((event, emit) {
      emit(event.isDarkMode ? ThemeMode.dark : ThemeMode.light);
    });
  }
}
