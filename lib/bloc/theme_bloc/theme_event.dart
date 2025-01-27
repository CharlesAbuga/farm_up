part of 'theme_bloc.dart';

abstract class ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  final bool isDarkMode;
  ThemeChanged(this.isDarkMode);
}

class ThemeSelected extends ThemeEvent {
  final ThemeData themeData;

  ThemeSelected(this.themeData);
}
