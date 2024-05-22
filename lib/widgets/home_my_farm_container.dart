import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeMyFarmContainer extends StatelessWidget {
  final String picUrl;
  final String title;
  final String number;

  const HomeMyFarmContainer(
      {super.key,
      required this.picUrl,
      required this.title,
      required this.number});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(1, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        height: 120,
        width: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: SvgPicture.asset(
                  picUrl,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 5,
        left: 10,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: Text(
            number, // Replace with your number of animals
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ]);
  }
}
