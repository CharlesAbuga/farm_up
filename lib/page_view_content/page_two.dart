import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IntroPageTwo extends StatelessWidget {
  const IntroPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child:
                        Image.asset(fit: BoxFit.cover, 'assets/images/3.gif')),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Center(
                child: Text('Get the latest updates on your farm.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary)),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
