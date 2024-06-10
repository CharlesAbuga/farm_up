import 'package:shared_preferences/shared_preferences.dart';

class FirstRun {
  Future<bool> isFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    return !prefs.containsKey('hasSeenIntro');
  }
}
