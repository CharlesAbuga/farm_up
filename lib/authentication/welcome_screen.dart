import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Welcome to FarmUp!'),
    );
  }
}
