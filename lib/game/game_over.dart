import 'package:balltrap/game/game_provider.dart';
import 'package:balltrap/home/home.dart';
import 'package:balltrap/models/game_session.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameOverScreen extends ConsumerWidget {
  const GameOverScreen(
      {super.key, required this.scores, required this.session});
  final List<Map<String, dynamic>> scores;
  final GameSession session;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(saveGameSessionProvider(session)).when(data: (_) {
      scores.sort((a, b) => b['score'].compareTo(a['score']));
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              ...scores.map((e) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor:
                        scores.indexOf(e) == 0 ? Colors.amber.shade50 : null,
                    title: Text(e['name']),
                    subtitle: Text(e['score'].toString()),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return const HomeView();
                    }), (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 75)),
                  child: const Text("HOME"),
                ),
              )
            ]),
          ),
        ),
      );
    }, loading: () {
      return const Center(child: CircularProgressIndicator.adaptive());
    }, error: (er, st) {
      debugPrintStack(stackTrace: st);
      return const Center(child: Text("failed to save to DB"));
    });
  }
}
