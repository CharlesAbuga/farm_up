import 'dart:ui';
import 'dart:math' as math;

import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/get_livestock/get_livestock_bloc.dart';
import 'package:farm_up/widgets/animal_detail_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:livestock_repository/livestock_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_repository/user_repository.dart';

class AnimalDetails extends StatefulWidget {
  final String livestockId;

  const AnimalDetails({super.key, required this.livestockId});

  @override
  State<AnimalDetails> createState() => _AnimalDetailsState();
}

class _AnimalDetailsState extends State<AnimalDetails>
    with SingleTickerProviderStateMixin {
  int selectedImage = 0;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Details'),
      ),
      body: BlocProvider(
        create: (context) => AuthenticationBloc(
            // Create a new instance of AuthenticationBloc
            myUserRepository: FirebaseUserRepository()),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return BlocProvider(
                create: (context) => GetLivestockBloc(
                    livestockRepository: FirebaseLivestockRepository())
                  ..add(GetLivestock(
                      context.read<AuthenticationBloc>().state.user!.uid)),
                child: BlocBuilder<GetLivestockBloc, GetLivestockState>(
                    builder: (context, state) {
                  if (state is GetLivestockSuccess) {
                    final livestock = state.livestock.firstWhere(
                      (element) => element.id == widget.livestockId,
                    );
                    //The body begins here with the livestock details
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BlocListener<GetLivestockBloc, GetLivestockState>(
                            listener: (context, state) {
                              if (state is GetLivestockLoading) {
                                SizedBox(
                                  height: 250,
                                  width: 300,
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Center(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.95,
                                width: MediaQuery.of(context).size.width * 0.95,
                                child: Stack(children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.95,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.assetNetwork(
                                        fadeInDuration:
                                            const Duration(seconds: 2),
                                        placeholder:
                                            'assets/images/placeholderimage.png',
                                        image: livestock.images![selectedImage],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        livestock.gender,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(1.0, 1.0),
                                              blurRadius: 3.0,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ...List.generate(
                                            livestock.images!.length,
                                            (index) =>
                                                smallPreview(index, livestock)),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // The text to show date of birth
                          dateOfBirthText(livestock: livestock),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.03),
                                child: Text('Animal Details',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    )),
                              ),
                            ],
                          ),
                          //The ListViews
                          ListViewsDetails(livestock: livestock),
                          //WaterEffectContainer(controller: _controller)
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.03),
                                child: Text('Actions',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    )),
                              ),
                            ],
                          ),
                          //The GridView
                          GridView.count(
                              crossAxisCount: 2,
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.03),
                              shrinkWrap: true,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 15,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Stack(fit: StackFit.expand, children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Vaccinations',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Icon(
                                        Icons.calendar_today,
                                        size: 20,
                                      )),
                                  Positioned(
                                    bottom: 15,
                                    right: 0,
                                    left: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('View Schedule',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize: 12,
                                                )),
                                            const SizedBox(width: 5),
                                            Icon(
                                              size: 30,
                                              CupertinoIcons
                                                  .arrow_right_circle_fill,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ])
                        ],
                      ),
                    );
                  }
                  // Return a circular progress indicator while the data is loading
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
              );
            }
            // Return an empty center widget if the user is not authenticated
            return const Center(
              child: SizedBox(),
            );
          },
        ),
      ),
    );
  }

  GestureDetector smallPreview(int index, Livestock livestock) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10, bottom: 5),
        padding: const EdgeInsets.all(0),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(
              width: 0.5,
              color:
                  selectedImage == index ? Colors.green : Colors.transparent),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(fit: StackFit.expand, children: [
            Image.network(livestock.images![index], fit: BoxFit.cover),
            if (selectedImage != index)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  color: Colors.black.withOpacity(0),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class WaterEffectContainer extends StatelessWidget {
  const WaterEffectContainer({
    super.key,
    required AnimationController controller,
  }) : _controller = controller;

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
          ),
        ],
        color: Colors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FractionallySizedBox(
            heightFactor: 0.75,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _WaterPainter(
                    clipper: LiquidClipper(animation: _controller),
                    color: Colors.green,
                  ),
                  child: Container(color: Colors.transparent),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterPainter extends CustomPainter {
  final LiquidClipper clipper;
  final Color color;

  _WaterPainter({required this.clipper, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = clipper.getClip(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LiquidClipper extends CustomClipper<Path> {
  final Animation<double> animation;

  LiquidClipper({required this.animation});

  @override
  Path getClip(Size size) {
    final path = Path();
    final double waveHeight = 20.0;
    final double waveFrequency = 2.0 * math.pi;

    path.moveTo(0.0, size.height);
    for (double x = 0.0; x < size.width; x += 1.0) {
      path.lineTo(
          x,
          size.height * 0.75 +
              (waveHeight *
                  math.sin(
                      (x / size.width) * waveFrequency * animation.value)));
    }

    path.lineTo(size.width, size.height * 0.75);
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class dateOfBirthText extends StatelessWidget {
  const dateOfBirthText({
    super.key,
    required this.livestock,
  });

  final Livestock livestock;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03),
      child: Row(
        children: [
          Row(
            children: [
              Icon(Icons.date_range,
                  color: Theme.of(context).colorScheme.onSurface),
              Text('Date of Birth: ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  )),
              const SizedBox(
                width: 5,
              ),
              Text(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                ),
                DateFormat('dd-MM-yyyy').format(livestock.birthDate),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ListViewsDetails extends StatelessWidget {
  const ListViewsDetails({
    super.key,
    required this.livestock,
  });

  final Livestock livestock;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        DetailCard(
          title: 'Name',
          value: livestock.name,
        ),
        DetailCard(
          title: 'Breed',
          value: livestock.breed,
        ),
      ],
    );
  }
}
