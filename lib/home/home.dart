import 'package:balltrap/home/addplayers.dart';
import 'package:balltrap/models/event.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
          child: ref.watch(_loadAnimationProvider).when(
              data: (lottie) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie(composition: lottie),
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple.shade50,
                                  minimumSize: const Size(double.infinity, 65)),
                              onPressed: () async {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return const AddPlayers();
                                }));
                              },
                              child: Text("Start New Game !!!".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                        ))
                      ]),
                );
              },
              error: (er, st) {
                debugPrintStack(stackTrace: st);
                return const Center(child: Text("Error"));
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()))),
    );
  }
}

final notesProvider = StateProvider<String>((ref) => '');
final titleProvider = StateProvider<String>((ref) => '');
final locationProvider = StateProvider<String>((ref) => '');
final eventsListProvider = StateProvider<List<EventType>>((ref) => []);
final _loadAnimationProvider = FutureProvider(
    (ref) => AssetLottie('assets/animations/welcome.json').load());
