import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatefulWidget {
  final String titlePage;
  const AppBarWidget({super.key, required this.titlePage});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: Border(
        bottom: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
      ),
      title: AnimatedCrossFade(
        firstChild: Text(widget.titlePage,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold)),
        secondChild: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search in ${widget.titlePage}',
            border: InputBorder.none,
          ),
        ),
        crossFadeState:
            _isSearching ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 200),
      ),
      actions: [
        IconButton(
          icon: !_isSearching
              ? const Icon(Icons.search)
              : const Icon(Icons.cancel_outlined),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const Center(
                    child: Text('Notifications'),
                  );
                });
          },
        ),
      ],
    );
  }
}
