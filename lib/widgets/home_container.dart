import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  final Icon icon;
  final String title;
  final String imageUrl;
  const HomeContainer(
      {super.key,
      required this.icon,
      required this.title,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        /* image: DecorationImage(
          opacity: 0.2,
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ), */
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon.icon,
              size: 50,
              color: Theme.of(context).colorScheme.surface,
            ),
            Text(
              '$title >',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
