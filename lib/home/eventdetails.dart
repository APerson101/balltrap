import 'package:balltrap/models/event.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EventDetails extends ConsumerWidget {
  const EventDetails({super.key, required this.item});
  final EventType item;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        body: const SingleChildScrollView(
          child: Column(children: []),
        ));
  }
}
