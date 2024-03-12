import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/game/game_over.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: _CurrentPlayer(players: players, template: template),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () async {
                    var scores = ref
                        .read(listofPlayersScoresProvider)
                        .map((entry) => {
                              'name': players[ref
                                      .watch(listofPlayersScoresProvider)
                                      .indexOf(entry)]
                                  .name,
                              'score': getScore(entry, template)
                            })
                        .toList();
                    final id = await ref.watch(getTabletIdProvider.future);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      final session = GameSession(
                          id: const Uuid().v4(),
                          template: template.name,
                          date: DateTime.now().toIso8601String(),
                          tablet: id ?? 0,
                          broken: ref.read(brokenpads),
                          playersScores: scores);
                      return GameOverScreen(scores: scores, session: session);
                    }));
                  },
                  child: const Text("Terminé",
                      style: TextStyle(
                          fontSize: 19, fontWeight: FontWeight.bold))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Cassé: ${ref.watch(brokenpads)}",
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
  }
}

class _CurrentPlayer extends ConsumerWidget {
  const _CurrentPlayer({required this.players, required this.template});
  final List players;
  final GameTemplate template;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'TOUR: ${players[ref.watch(currentPlayerProvider)].name} (${getTurnsLeft(ref, template).toString()})',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20))));
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
        var scores = ref.watch(listofPlayersScoresProvider);
        List<int> player;
        try {
          player = scores[index];
        } catch (_) {
          player = List.generate(25, (index) => 0);
        }
        var score = player.reduce((value, element) => value + element);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
                tileColor: ref.watch(currentPlayerProvider) == index
                    ? const Color.fromRGBO(176, 197, 164, 1)
                    : null,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(players[index].name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                trailing: Text(
                  score.toString(),
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                subtitle: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(25, (boxindex) {
                    return Padding(
                        padding: EdgeInsets.only(
                            right: template.playerMovements.contains(boxindex)
                                ? 20
                                : 1),
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: _BoxIcon(
                              currentPlayer: index,
                              currentBox: boxindex,
                              template: template,
                              letters: template.letters,
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
      required this.letters,
      required this.template});
  final int currentPlayer;
  final int currentBox;
  final GameTemplate template;
  final List<String> letters;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (currentPlayer == ref.watch(currentPlayerProvider) &&
        currentBox == ref.watch(_currentRoundProvider)) {
      return DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(letters[currentBox],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
          ));
    }
    List<int> playerScores;

    try {
      playerScores = ref.watch(listofPlayersScoresProvider)[currentPlayer];
    } catch (_) {
      playerScores = List.generate(25, (index) => 0);
    }

    if (playerScores[currentBox] > ref.watch(_currentRoundProvider)) {
      return DecoratedBox(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: template.doubleIndexes.contains(currentBox) == false
                  ? Colors.grey
                  : Colors.amber),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(letters[currentBox],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
          ));
    }
    if (playerScores[currentBox] < ref.watch(_currentRoundProvider)) {
      return Badge(
        label: const Icon(Icons.gpp_good),
        child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: template.doubleIndexes.contains(currentBox) == false
                  ? Colors.grey
                  : Colors.amber,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(letters[currentBox],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 40)),
            )),
      );
    }

    return DecoratedBox(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: template.doubleIndexes.contains(currentBox) == false
                ? Colors.grey
                : Colors.amber),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(letters[currentBox],
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
        ));
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
          if (item == _ActionButtons.second && !template.dtl) {
            return Container();
          }
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
                        state[ref.watch(currentPlayerProvider)].removeLast();
                        return state;
                      });
                    }
                    if (item == _ActionButtons.hit) {
                      print({
                        'current player',
                        ref.watch(currentPlayerProvider),
                        'current round',
                        ref.watch(_currentRoundProvider),
                        'turn',
                        ref.watch(turnsPlayedProvider),
                      });
                      try {
                        ref
                            .watch(listofPlayersScoresProvider.notifier)
                            .update((state) {
                          if (ref.watch(turnsPlayedProvider) < 5) {
                            print({
                              'all user scores before updating are: ',
                              state[ref.watch(currentPlayerProvider)]
                            });
                            var currentRoundTotal =
                                state[ref.watch(currentPlayerProvider)]
                                    [ref.watch(_currentRoundProvider)];
                            var addedScore =
                                template.dtl ? 3 : 1 + currentRoundTotal;
                            state[ref.watch(currentPlayerProvider)]
                                [ref.watch(_currentRoundProvider)] = addedScore;
                            print({
                              'all user scores after updating are: ',
                              state[ref.watch(currentPlayerProvider)]
                            });
                          } else {
                            state[ref.watch(currentPlayerProvider)]
                                [ref.watch(_currentRoundProvider)] = 1;
                          }
                          state = [...state];
                          return state;
                        });
                      } catch (_) {
                        ref
                            .watch(listofPlayersScoresProvider.notifier)
                            .update((state) {
                          state.add([1, ...List.generate(24, (_) => 0)]);
                          state = [...state];
                          return state;
                        });
                      }
                      addAction(ref);
                    }
                    if (item == _ActionButtons.miss) {
                      if (template.doubleIndexes.contains(ref
                              .watch(listofPlayersScoresProvider)[
                                  ref.watch(currentPlayerProvider)]
                              .length) ||
                          template.dtl) {
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

                      addAction(ref);
                    }
                    if (item == _ActionButtons.broken) {
                      ref.watch(brokenpads.notifier).update((state) {
                        state += 1;
                        return state;
                      });
                      return;
                    }

                    if (item == _ActionButtons.second) {
                      // add 2 points

                      try {
                        ref
                            .watch(listofPlayersScoresProvider.notifier)
                            .update((state) {
                          if (ref.watch(turnsPlayedProvider) < 5) {
                            var currentRoundTotal =
                                state[ref.watch(currentPlayerProvider)]
                                    [ref.watch(_currentRoundProvider)];
                            var addedScore = 2 + currentRoundTotal;
                            state[ref.watch(currentPlayerProvider)]
                                [ref.watch(_currentRoundProvider)] = addedScore;
                          } else {
                            state[ref.watch(currentPlayerProvider)]
                                [ref.watch(_currentRoundProvider)] = 1;
                          }
                          state = [...state];
                          return state;
                        });
                      } catch (_) {
                        ref
                            .watch(listofPlayersScoresProvider.notifier)
                            .update((state) {
                          state.add([2, ...List.generate(24, (_) => 0)]);
                          state = [...state];
                          return state;
                        });
                      }
                      ref
                          .watch(listofPlayersScoresProvider.notifier)
                          .update((state) {
                        state[ref.watch(currentPlayerProvider)].add(0);
                        return state;
                      });
                      addAction(ref);
                    }

                    ref.watch(roundsPlayed.notifier).update((state) {
                      state += 1;
                      return state;
                    });
                    if (ref.watch(roundsPlayed) == (25 * players.length)) {
                      // move to game over screen
                      var scores = ref
                          .read(listofPlayersScoresProvider)
                          .map((entry) => {
                                'name': players[ref
                                        .watch(listofPlayersScoresProvider)
                                        .indexOf(entry)]
                                    .name,
                                'score': getScore(entry, template)
                              })
                          .toList();
                      final id = await ref.watch(getTabletIdProvider.future);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        final session = GameSession(
                            id: const Uuid().v4(),
                            date: DateTime.now().toIso8601String(),
                            tablet: id ?? 0,
                            template: template.name,
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
    ref.watch(turnsPlayedProvider.notifier).update((state) => state + 1);

    if (ref.watch(turnsPlayedProvider) == 5) {
      ref.watch(turnsPlayedProvider.notifier).state = 0;
      ref.watch(currentPlayerProvider.notifier).update((state) {
        state += 1;
        return state;
      });
      if (ref.watch(currentPlayerProvider) == players.length) {
        ref.watch(_currentRoundProvider.notifier).update((state) => state + 1);
      }
      if (ref.watch(currentPlayerProvider) == players.length) {
        ref.watch(currentPlayerProvider.notifier).update((state) => 0);
      }
    }
  }
}

class ScoreCalculator extends ConsumerWidget {
  const ScoreCalculator({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var player = ref.watch(listofPlayersScoresProvider)[index];
    var hitCount = player.where((e) => e == 1).length ?? 0;
    var secondCount = player.where((e) => e == 0).length ?? 0;
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

final turnsPlayedProvider = StateProvider((ref) => 0);
final _currentRoundProvider = StateProvider((ref) => 0);
final doubleMissProvider = StateProvider((ref) => 0);
final currentPlayerProvider = StateProvider.autoDispose<int>((ref) => 0);
final listofPlayersScoresProvider =
    StateProvider.autoDispose<List<List<int>>>((ref) => []);
final brokenpads = StateProvider.autoDispose((ref) => 0);
final roundsPlayed = StateProvider((ref) => 0);

int getScore(List<int> scores, GameTemplate template) {
  return scores.reduce((value, element) => value + element);
}

int getTurnsLeft(WidgetRef ref, GameTemplate template) {
  final turnsLeft = (ref.watch(turnsPlayedProvider) - 5).abs();
  final doublePlay =
      template.doubleIndexes.contains(ref.watch(_currentRoundProvider)) ? 1 : 0;
  return turnsLeft + doublePlay;
}
