import 'package:balltrap/home/home.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameOverScreen extends ConsumerWidget {
  const GameOverScreen({super.key, required this.scores});
  final List<Map<String, dynamic>> scores;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    scores.sort((a, b) => b['score'].compareTo(a['score']));
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          ...scores.map((e) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                tileColor: scores.indexOf(e) == 0 ? Colors.amber.shade50 : null,
                title: Text(e['name']),
                subtitle: Text(e['score'].toString()),
              ),
            );
          }),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return const HomeView();
              }));
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 75)),
            child: const Text("HOME"),
          )
        ]),
      ),
    );
  }
}
