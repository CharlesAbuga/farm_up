import 'package:farm_up/main_app.dart';
import 'package:farm_up/page_view_content/page_one.dart';
import 'package:farm_up/page_view_content/page_three.dart';
import 'package:farm_up/page_view_content/page_two.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:user_repository/user_repository.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController smoothController = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: smoothController,
          onPageChanged: (index) {
            setState(() {
              onLastPage = index == 2;
            });
          },
          children: const [IntroPageOne(), IntroPageTwo(), IntroPageThree()],
        ),
        Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Skip Button to the last page

                onLastPage
                    ? const SizedBox()
                    : TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          surfaceTintColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          smoothController.jumpToPage(2);
                        },
                        child: const Text('Skip')),

                SmoothPageIndicator(
                    controller: smoothController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                        dotWidth: 15,
                        dotHeight: 15,
                        activeDotColor: Theme.of(context).colorScheme.secondary,
                        dotColor: Theme.of(context).colorScheme.primary)),
                onLastPage
                    ? TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          surfaceTintColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('hasSeenIntro', true);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MainApp(FirebaseUserRepository())),
                          );
                        },
                        child: const Text('Get Started'))
                    : TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          surfaceTintColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          smoothController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: const Text('Next')),
              ],
            ))
      ],
    ));
  }
}
