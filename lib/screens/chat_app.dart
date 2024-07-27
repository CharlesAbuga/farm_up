import 'package:farm_up/bloc/gemini_chat/gemini_chat_bloc.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  final scrollController = ScrollController();
  int _previousMessageCount = 0;

  final spinkit = const SpinKitThreeBounce(
    color: Colors.white,
    size: 50.0,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 1), upperBound: 1.3);
    _controller.forward();
  }

  void _scrollToEnd() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();

    return AnimatedBuilder(
        animation: _controller,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Chat with Assistant',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                Column(
                  children: [
                    Image.asset('assets/images/google-gemini-icon.png',
                        width: 20, height: 20),
                    const Text('Powered by Gemini',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.black,
                        )),
                  ],
                ),
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoaded) {
                    if (state.messages.length > _previousMessageCount) {
                      _previousMessageCount = state.messages.length;
                      _scrollToEnd();
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.messages.length,
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              final message = state.messages[index];
                              return Align(
                                alignment: message.isUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: message.isUser
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(message.text),
                                ).animate().slide(
                                      begin: Offset(
                                          message.isUser ? 0.5 : -0.5, 0.0),
                                      end: const Offset(0, 0),
                                      curve: Curves.easeIn,
                                    ),
                              );
                            },
                          ),
                        ),
                        if (state.isLoading)
                          const Row(
                            children: [
                              SpinKitThreeBounce(
                                color: Colors.green,
                                size: 50.0,
                              ),
                            ],
                          ),
                      ],
                    );
                  } else if (state is ChatLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Enter prompt to start chat',
                                style: TextStyle(
                                  fontSize: 17,
                                ))
                            .animate()
                            .fade(
                                delay: const Duration(milliseconds: 200),
                                duration: const Duration(milliseconds: 500),
                                begin: 0.0,
                                end: 1.0,
                                curve: Curves.easeIn)
                            .slide(
                                delay: const Duration(milliseconds: 200),
                                duration: const Duration(milliseconds: 500),
                                begin: const Offset(0.5, 0.0),
                                end: const Offset(0, 0),
                                curve: Curves.easeIn),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.message_outlined,
                                size: 30,
                                color: Theme.of(context).colorScheme.primary)
                            .animate()
                            .fade(
                                delay: const Duration(milliseconds: 500),
                                duration: const Duration(milliseconds: 500),
                                begin: 0.0,
                                end: 1.0,
                                curve: Curves.easeIn)
                            .slide(
                                delay: const Duration(milliseconds: 700),
                                duration: const Duration(milliseconds: 500),
                                begin: const Offset(0.0, 0.5),
                                end: const Offset(0, 0),
                                curve: Curves.easeIn),
                      ],
                    ));
                  }
                },
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatBloc.promptController,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.mic_none),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                            ),
                            labelText: 'Enter your prompt',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      IconButton.filled(
                        iconSize: 25,
                        color: Theme.of(context).colorScheme.onSurface,
                        icon: const Icon(Icons.send_outlined),
                        padding: const EdgeInsets.all(15),
                        onPressed: () {
                          final message = chatBloc.promptController.text;
                          if (message.isNotEmpty) {
                            chatBloc.add(SendMessageEvent(message));
                            chatBloc.promptController.clear();
                            FocusScope.of(context).unfocus();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.4),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            onPressed: () {
              _controller.reverse().then(
                (value) {
                  Navigator.of(context).pop();
                },
              );
            },
            child: const Icon(Icons.close),
          ),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(
              MediaQuery.of(context).viewInsets.bottom + 90),
        ),
        builder: (context, child) {
          return ClipPath(
            clipper: MyClipper(value: _controller.value),
            child: child,
          );
        });
  }
}

class MyClipper extends CustomClipper<Path> {
  final double value;

  MyClipper({super.reclip, required this.value});

  @override
  Path getClip(Size size) {
    var path = Path();
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width, size.height),
        radius: value * size.height,
      ),
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double offset;

  CustomFloatingActionButtonLocation(this.offset);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.floatingActionButtonSize.width -
        16.0;
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        offset;
    return Offset(fabX, fabY);
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}
