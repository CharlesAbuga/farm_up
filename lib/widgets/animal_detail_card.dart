import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final dynamic value;
  const DetailCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.outline,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value.toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.outline,
            fontSize: 14,
          ),
        ),
        trailing: ClipRRect(
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.primary),
            ),
            icon: const Icon(size: 18, Icons.edit),
            onPressed: () {},
          ),
        ));
  }
}
