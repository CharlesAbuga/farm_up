import 'package:flutter/material.dart';

class AddFeedingScreen extends StatelessWidget {
  final String animalType;
  const AddFeedingScreen({super.key, required this.animalType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Types'),
      ),
      body: Center(
        child: Text('Animal Type: $animalType'),
      ),
    );
  }
}
