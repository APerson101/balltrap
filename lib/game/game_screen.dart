import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/game/game_over.dart';
import 'package:balltrap/game/game_provider.dart';
import 'package:balltrap/models/game_session.dart';
import 'package:balltrap/models/game_template.dart';
import 'package:balltrap/models/player_tag.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key, required this.template, required this.players});
  final GameTemplate template;
  final List<PlayerDetails> players;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(setConfigurationProvider(players)).when(data: (_) {
      return Scaffold(
          appBar: AppBar(
            title: _CurrentPlayer(players: players),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () async {
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
                      final id = await ref.watch(getTabletIdProvider.future);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        final session = GameSession(
                            id: const Uuid().v4(),
                            date: DateTime.now().toIso8601String(),
                            tablet: id ?? 0,
                            broken: ref.read(brokenpads),
                            playersScores: scores);
                        return GameOverScreen(scores: scores, session: session);
                      }));
                    },
                    child: const Text("Terminé")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("No-birds: ${ref.watch(brokenpads)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              )
            ],
          ),
          body: SafeArea(
            child: Stack(children: [
              Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: MediaQuery.of(context).size.height * .5,
                  child: _ScoreCards(players: players, template: template)),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _Buttons(
                    players: players,
                    template: template,
                  )),
            ]),
          ));
    }, error: (Object error, StackTrace stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      return const Center(child: Text("Échec de la configuration du jeu"));
    }, loading: () {
      return const CircularProgressIndicator.adaptive();
    });
  }
}

class _CurrentPlayer extends ConsumerWidget {
  const _CurrentPlayer({required this.players});
  final List players;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Tour de : ${players[ref.watch(currentPlayerProvider)].name}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}

class _ScoreCards extends ConsumerWidget {
  const _ScoreCards({required this.players, required this.template});
  final List players;
  final GameTemplate template;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
          children: List.generate(players.length, (index) {
        var player = ref.watch(listofPlayersScoresProvider)['$index'];
        var hitCount = player?.where((e) => e == 1).length ?? 0;
        var secondCount = player?.where((e) => e == 0).length ?? 0;
        var score = ((3 * hitCount) + (2 * secondCount));
        ref.watch(listofPlayersScoresProvider);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
                tileColor: ref.watch(currentPlayerProvider) == index
                    ? const Color(0xffb0c5a4)
                    : null,
                title: Text(players[index].name),
                trailing: Text(
                  score.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(25, (boxindex) {
                    return Padding(
                        padding: EdgeInsets.only(
                            right: (boxindex + 1) % 5 == 0 ? 20 : 1),
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: _BoxIcon(
                              currentPlayer: index,
                              currentBox: boxindex,
                              template: template,
                            )));
                  })),
                )),
          ),
        );
      })),
    );
  }
}

class _BoxIcon extends ConsumerWidget {
  const _BoxIcon(
      {required this.currentPlayer,
      required this.currentBox,
      required this.template});
  final int currentPlayer;
  final int currentBox;
  final GameTemplate template;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (currentPlayer == ref.watch(currentPlayerProvider)) {
      if (currentBox ==
          ref
              .watch(listofPlayersScoresProvider)[currentPlayer.toString()]!
              .length) {
        return DecoratedBox(
            decoration: BoxDecoration(
                color: const Color(0x56d37676),
                borderRadius: BorderRadius.circular(20)),
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
        var type = playerScores[currentBox];
        switch (type) {
          case 1:
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: template.doubleIndexes.contains(currentBox) == false
                        ? Colors.grey
                        : Colors.amber,
                    borderRadius: BorderRadius.circular(20)),
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(Icons.filter_tilt_shift),
                ));
          case -1:
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: template.doubleIndexes.contains(currentBox) == false
                        ? Colors.grey
                        : Colors.amber,
                    borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.cancel));
        }
      } catch (e) {
        // turn has not been gotten to yet, return empty box
        return DecoratedBox(
            decoration: BoxDecoration(
                color: template.doubleIndexes.contains(currentBox) == false
                    ? Colors.grey
                    : Colors.amber,
                borderRadius: BorderRadius.circular(20)),
            child: const SizedBox(height: 24, width: 24));
      }
    }

    return DecoratedBox(
        decoration: BoxDecoration(
            color: template.doubleIndexes.contains(currentBox) == false
                ? Colors.grey
                : Colors.amber,
            borderRadius: BorderRadius.circular(20)),
        child: const SizedBox(height: 24, width: 24));
  }
}

class _Buttons extends ConsumerWidget {
  const _Buttons({required this.players, required this.template});
  final List<PlayerDetails> players;
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
                  onTap: () async {
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
                      if (template.doubleIndexes.contains(ref
                          .watch(listofPlayersScoresProvider)[
                              "${ref.watch(currentPlayerProvider)}"]!
                          .length)) {
                        // check if it contains already:: if user has played and is on the double shot
                        ref.watch(doubleMissProvider.notifier).update((state) {
                          state += 1;
                          return state;
                        });

                        if (ref.watch(doubleMissProvider) == 2) {
                          // record as miss and clear
                          ref
                              .watch(doubleMissProvider.notifier)
                              .update((state) {
                            state = 0;
                            return state;
                          });
                        } else {
                          return;
                        }
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
                      return;
                    }

                    ref.watch(roundsPlayed.notifier).update((state) {
                      state += 1;
                      return state;
                    });
                    if (ref.watch(roundsPlayed) == (25 * players.length)) {
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
                      final id = await ref.watch(getTabletIdProvider.future);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        final session = GameSession(
                            id: const Uuid().v4(),
                            date: DateTime.now().toIso8601String(),
                            config: id ?? 0,
                            broken: ref.read(brokenpads),
                            playersScores: scores);
                        return GameOverScreen(scores: scores, session: session);
                      }));
                    }
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: item.color,
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
  broken(
      label: 'no-bird', icondata: Icons.broken_image, color: Color(0xffffffff)),
  undo(label: 'annuler', icondata: Icons.undo, color: Color(0xffffffff)),
  miss(
      label: "miss", icondata: Icons.circle_outlined, color: Color(0xffD37676)),

  second(
      label: "second",
      icondata: Icons.looks_two_rounded,
      color: Color(0xffEBC49F)),
  hit(
      label: "hit",
      icondata: Icons.filter_tilt_shift,
      color: Color(0xffB0C5A4));

  const _ActionButtons(
      {required this.label, required this.icondata, required this.color});
  final String label;
  final Color color;
  final IconData icondata;
}

final doubleMissProvider = StateProvider((ref) => 0);
final currentPlayerProvider = StateProvider.autoDispose<int>((ref) => 0);
final listofPlayersScoresProvider =
    StateProvider.autoDispose<Map<String, List<int>>>((ref) => {});
final brokenpads = StateProvider.autoDispose((ref) => 0);
final roundsPlayed = StateProvider((ref) => 0);

int getScore(List<int> scores) {
  var hit = scores.where((element) => element == 1).length;
  var sc = scores.where((element) => element == 0).length;
  return ((3 * hit) + (2 * sc));
}
