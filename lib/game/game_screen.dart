import 'package:balltrap/game/game_over.dart';
import 'package:balltrap/game/game_provider.dart';
import 'package:balltrap/models/game_template.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key, required this.template});
  final GameTemplate template;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getSessionPlayersProvider).when(
        data: (players) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Score"),
                actions: [
                  TextButton(onPressed: () {}, child: const Text("DONE")),
                  Text("Broken: ${ref.watch(brokenpads)}")
                ],
                leading: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: Stack(children: [
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _CurrentPlayer(players: players))),
                Positioned(
                    left: 0,
                    right: 0,
                    top: 40,
                    child: _ScoreCards(players: players, template: template)),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _Buttons(
                      players: players,
                      template: template,
                    )),
              ]));
        },
        error: (er, st) {
          debugPrintStack(stackTrace: st);
          return const Text("Failed to fetch data");
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()));
  }
}

class _CurrentPlayer extends ConsumerWidget {
  const _CurrentPlayer({required this.players});
  final List players;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: Column(children: [
      Text(players[ref.watch(currentPlayerProvider)].name),
      const Text("Station ")
    ]));
  }
}

class _ScoreCards extends ConsumerWidget {
  const _ScoreCards({required this.players, required this.template});
  final List players;
  final GameTemplate template;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
        children: List.generate(players.length, (index) {
      var player = ref.watch(listofPlayersScoresProvider)['$index'];
      var hitCount = player?.where((e) => e == 1).length ?? 0;
      var secondCount = player?.where((e) => e == 0).length ?? 0;
      var score = ((3 * hitCount) + (2 * secondCount));
      ref.watch(listofPlayersScoresProvider);
      return ListTile(
          tileColor: ref.watch(currentPlayerProvider) == index
              ? Colors.greenAccent
              : null,
          title: Text(players[index].name),
          trailing: Text(score.toString()),
          subtitle: Row(
              children: List.generate(25, (boxindex) {
            return Padding(
                padding:
                    EdgeInsets.only(right: (boxindex + 1) % 5 == 0 ? 20 : 1),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color:
                            template.doubleIndexes.contains(boxindex) == false
                                ? Colors.grey
                                : Colors.amber,
                        borderRadius: BorderRadius.circular(20)),
                    child: _BoxIcon(
                      currentPlayer: index,
                      currentTurn: boxindex,
                      template: template,
                    )));
          })));
    }));
  }
}

class _BoxIcon extends ConsumerWidget {
  const _BoxIcon(
      {required this.currentPlayer,
      required this.currentTurn,
      required this.template});
  final int currentPlayer;
  final int currentTurn;
  final GameTemplate template;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (currentPlayer == ref.watch(currentPlayerProvider)) {
      // current player is about to player
      if (currentTurn + 1 ==
          ref
                  .watch(listofPlayersScoresProvider)[currentPlayer.toString()]!
                  .length +
              1) {
        return DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(20)),
            child: const SizedBox(
              height: 24,
              width: 24,
            ));
      }
    }
    var playerScores =
        ref.watch(listofPlayersScoresProvider)[currentPlayer.toString()];
    if (playerScores!.isNotEmpty) {
      // has played, set appropriate colors
      try {
        var type = playerScores[currentTurn];
        switch (type) {
          case 1:
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: template.doubleIndexes.contains(currentTurn) == false
                        ? Colors.grey
                        : Colors.amber,
                    borderRadius: BorderRadius.circular(20)),
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(Icons.gpp_good),
                ));
          case -1:
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: template.doubleIndexes.contains(currentTurn) == false
                        ? Colors.grey
                        : Colors.amber,
                    borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.cancel));
          case 0:
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: template.doubleIndexes.contains(currentTurn) == false
                        ? Colors.grey
                        : Colors.amber,
                    borderRadius: BorderRadius.circular(20)),
                child: const Icon(
                  Icons.looks_two_rounded,
                ));
        }
      } catch (e) {
        // turn has not been gotten to yet, return empty box
        return DecoratedBox(
            decoration: BoxDecoration(
                color: template.doubleIndexes.contains(currentTurn) == false
                    ? Colors.grey
                    : Colors.amber,
                borderRadius: BorderRadius.circular(20)),
            child: const SizedBox(height: 24, width: 24));
      }
    }

    return DecoratedBox(
        decoration: BoxDecoration(
            color: template.doubleIndexes.contains(currentTurn) == false
                ? Colors.grey
                : Colors.amber,
            borderRadius: BorderRadius.circular(20)),
        child: const SizedBox(height: 24, width: 24));
  }
}

class _Buttons extends ConsumerWidget {
  const _Buttons({required this.players, required this.template});
  final List<PlayerData> players;
  final GameTemplate template;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _ActionButtons.values.map((item) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    // if (template.doubleIndexes
                    //     .contains(ref.watch(_roundsPlayed))) {
                    //   var currentPlayer =
                    //       players[ref.watch(currentPlayerProvider)];
                    //   var currentDoublePlays =
                    //       ref.watch(_doublePlayProvider)[currentPlayer]!;

                    //   var numberOfTimesPlayed = currentDoublePlays
                    //       .where(
                    //           (element) => element == ref.read(_roundsPlayed))
                    //       .length;

                    //   if (numberOfTimesPlayed < 2) {
                    //     ref.watch(_doublePlayProvider.notifier).update((state) {
                    //       state[currentPlayer]!.add(ref.watch(_roundsPlayed));
                    //       return state;
                    //     });
                    //     // stay in place but increment score
                    //   }
                    // }
                    if (item == _ActionButtons.undo) {
                      ref.watch(currentPlayerProvider.notifier).update((state) {
                        state -= 1;
                        return state;
                      });
                      if (ref.watch(currentPlayerProvider) == -1) {
                        ref
                            .watch(currentPlayerProvider.notifier)
                            .update((state) => players.length - 1);
                      }
                      ref
                          .watch(listofPlayersScoresProvider.notifier)
                          .update((state) {
                        state["${ref.watch(currentPlayerProvider)}"]!
                            .removeLast();
                        return state;
                      });
                    }
                    if (item == _ActionButtons.hit) {
                      ref
                          .watch(listofPlayersScoresProvider.notifier)
                          .update((state) {
                        state["${ref.watch(currentPlayerProvider)}"]!.add(1);
                        return state;
                      });
                      addAction(ref);
                    }
                    if (item == _ActionButtons.miss) {
                      if (template.doubleIndexes
                          .contains(ref.watch(_roundsPlayed))) {
                        return;
                      }
                      ref
                          .watch(listofPlayersScoresProvider.notifier)
                          .update((state) {
                        state["${ref.watch(currentPlayerProvider)}"]!.add(-1);
                        return state;
                      });
                      addAction(ref);
                    }
                    if (item == _ActionButtons.broken) {
                      ref.watch(brokenpads.notifier).update((state) {
                        state += 1;
                        return state;
                      });
                    }

                    ref.watch(_roundsPlayed.notifier).update((state) {
                      state += 1;
                      return state;
                    });
                    if (ref.watch(_roundsPlayed) == (25 * players.length)) {
                      // move to game over screen
                      var scores = ref
                          .read(listofPlayersScoresProvider)
                          .entries
                          .toList()
                          .map((entry) => {
                                'name': players[int.parse(entry.key)].name,
                                'score': getScore(entry.value)
                              })
                          .toList();
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return GameOverScreen(scores: scores);
                      }));
                    }
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 40, bottom: 40),
                      child: Column(children: [
                        Icon(item.icondata),
                        const SizedBox(height: 5),
                        Text(item.label.toUpperCase()),
                      ]),
                    ),
                  )),
            ),
          );
        }).toList());
  }

  int getScore(List<int> scores) {
    var hit = scores.where((element) => element == 1).length;
    var sc = scores.where((element) => element == 0).length;
    return ((3 * hit) + (2 * sc));
  }

  void addAction(WidgetRef ref) {
    ref.watch(currentPlayerProvider.notifier).update((state) {
      state += 1;
      return state;
    });
    if (ref.watch(currentPlayerProvider) == players.length) {
      ref.watch(currentPlayerProvider.notifier).update((state) => 0);
    }
  }
}

class ScoreCalculator extends ConsumerWidget {
  const ScoreCalculator({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var player = ref.watch(listofPlayersScoresProvider)['$index'];
    var hitCount = player?.where((e) => e == 1).length ?? 0;
    var secondCount = player?.where((e) => e == 0).length ?? 0;
    var score = ((3 * hitCount) + (2 * secondCount));
    return Text(score.toString());
  }
}

enum _ActionButtons {
  undo(label: 'undo', icondata: Icons.undo),
  miss(label: "miss", icondata: Icons.circle_outlined),
  broken(label: 'broken', icondata: Icons.broken_image),
  hit(label: "hit", icondata: Icons.turn_sharp_right_rounded);

  const _ActionButtons({required this.label, required this.icondata});
  final String label;
  final IconData icondata;
}

final currentPlayerProvider = StateProvider<int>((ref) => 0);
final listofPlayersScoresProvider =
    StateProvider<Map<String, List<int>>>((ref) => {});
final sessionScoresProvider = StateProvider<List<int>>((ref) => []);
final brokenpads = StateProvider((ref) => 0);
final _roundsPlayed = StateProvider((ref) => 0);
final doublePlayProvider =
    StateProvider<Map<({String id, String name, int startingStation}), List>>(
        (ref) => {});
