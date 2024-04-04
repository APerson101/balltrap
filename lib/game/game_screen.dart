import 'package:balltrap/game/game_over.dart';
import 'package:balltrap/models/game_session.dart';
import 'package:balltrap/models/game_template.dart';
import 'package:balltrap/models/player_tag.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class GameScreen extends ConsumerWidget {
  GameScreen({super.key, required this.template, required this.players})
      : ballKeys = List.generate(players.length,
            (index) => List.generate(25, (index) => GlobalKey())),
        playersKeys = List.generate(players.length, (index) => GlobalKey());
  final GameTemplate template;
  final List<PlayerDetails> players;
  final List<List<GlobalKey>> ballKeys;
  final List<GlobalKey> playersKeys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            title: _CurrentPlayer(players: players, template: template),
            centerTitle: true,
            actions: [
              // ElevatedButton(
              //     onPressed: () async {
              //       final simulatedDate = await showDatePicker(
              //           context: context,
              //           firstDate: DateTime(2023, 1, 1),
              //           lastDate: DateTime.now());
              //       if (simulatedDate != null) {
              //         ref.watch(_simuatedDate.notifier).state = simulatedDate;
              //       }
              //     },
              //     child: const Text("Select date")),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () async {
                      var scores = ref
                          .read(listofPlayersScoresProvider)
                          .map((entry) => {
                                'name': players[ref
                                        .read(listofPlayersScoresProvider)
                                        .indexOf(entry)]
                                    .name,
                                'score': getScore(entry, template),
                                'id': players[ref
                                        .watch(listofPlayersScoresProvider)
                                        .indexOf(entry)]
                                    .id
                              })
                          .toList();
                      int hit = ref
                          .read(listofPlayersScoresProvider)
                          .map((scores) =>
                              scores.where((score) => score > 0).length)
                          .reduce((value, element) => value + element);
                      int miss = ref
                          .read(listofPlayersScoresProvider)
                          .map((scores) => scores
                              .where((score) => score == 0 || score == 2)
                              .length)
                          .reduce((value, element) => value + element);
                      int broken = ref.read(brokenpads);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        final session = GameSession(
                            id: const Uuid().v4(),
                            hit: hit,
                            miss: miss,
                            template: template.name,
                            // date: ref.watch(_simuatedDate)!.toIso8601String(),
                            date: DateTime.now().toIso8601String(),
                            broken: broken,
                            playersScores: scores);
                        return GameOverScreen(
                            scores: scores,
                            session: session,
                            players: players,
                            ids: players.map((e) => e.id).toList());
                      }));

                      resetEverything(ref);
                    },
                    child: const Text("Terminé",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("No-bird: ${ref.watch(brokenpads)}",
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
                  height: MediaQuery.of(context).size.height,
                  child: _ScoreCards(
                      players: players,
                      template: template,
                      turnKeys: ballKeys,
                      playerKeys: playersKeys)),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _Buttons(
                    players: players,
                    template: template,
                    playersKeys: playersKeys,
                    turnKeys: ballKeys,
                  )),
            ]),
          )),
    );
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
                'TOUR: ${players[ref.watch(currentPlayerProvider)].name}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20))));
  }
}

class _ScoreCards extends ConsumerWidget {
  const _ScoreCards(
      {required this.players,
      required this.template,
      required this.turnKeys,
      required this.playerKeys});
  final List players;
  final GameTemplate template;
  final List<List<GlobalKey>> turnKeys;
  final List<GlobalKey> playerKeys;

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
          key: playerKeys[index],
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
                  template.dtl ? '$score/75' : '$score/25',
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                subtitle: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(25, (boxindex) {
                    if (template.doubleIndexes.contains(boxindex - 1)) {
                      return Container();
                    }

                    if (template.doubleIndexes.contains(boxindex)) {
                      return Padding(
                        key: turnKeys[index][boxindex],
                        padding: EdgeInsets.only(
                            right: (template.playerMovements
                                            .contains(boxindex + 1) &&
                                        !template.compak) ||
                                    (template.compak && (boxindex + 2) % 5 == 0)
                                ? 20
                                : 3),
                        child: SizedBox(
                          width: 100,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    DecoratedBox(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: _BoxIcon(
                                          currentPlayer: index,
                                          currentBox: boxindex,
                                          template: template,
                                          letters: template.letters,
                                        )),
                                    DecoratedBox(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: _BoxIcon(
                                          currentPlayer: index,
                                          currentBox: boxindex + 1,
                                          template: template,
                                          letters: template.letters,
                                        ))
                                  ]),
                            ),
                          ),
                        ),
                      );
                    }
                    return Padding(
                        key: turnKeys[index][boxindex],
                        padding: EdgeInsets.only(
                            right: template.playerMovements
                                        .contains(boxindex) ||
                                    (template.compak && (boxindex + 1) % 5 == 0)
                                ? 20
                                : 3),
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: _BoxIcon(
                                currentPlayer: index,
                                currentBox: boxindex,
                                template: template,
                                letters: template.letters)));
                  })),
                )),
          ),
        );
      })),
    );
  }
}

class _BoxIcon extends ConsumerWidget {
  _BoxIcon(
      {required this.currentPlayer,
      required this.currentBox,
      required this.letters,
      required this.template});
  int currentPlayer;
  final int currentBox;
  final GameTemplate template;
  final List<String> letters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String letterToShowIndex;

    try {
      if (currentPlayer >= letters.length) {
        currentPlayer = letters.indexOf(letters.last);
      }
      if (template.compak) {
        // int ind = currentPlayer + ((currentBox / 5).floor() % letters.length);
        int ind = ((currentPlayer * 5) + currentBox) % letters.length;
        letterToShowIndex = letters[ind];
      } else {
        letterToShowIndex = letters[currentBox];
      }
    } catch (e) {
      int ind = (currentPlayer + ((currentBox / 5).floor() % letters.length)) %
          letters.length;
      letterToShowIndex = letters[ind];
    }
    if (currentPlayer == ref.watch(currentPlayerProvider) &&
        currentBox == ref.watch(_currentRoundProvider)) {
      return SizedBox(
        height: 40,
        width: 40,
        child: DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple,
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(letterToShowIndex,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 40)),
            )),
      );
    }
    List<int> playerScores;
    int stat;

    try {
      playerScores = ref.watch(listofPlayersScoresProvider)[currentPlayer];
    } catch (_) {
      playerScores = [];
    }
    try {
      stat = playerScores[currentBox];
    } catch (_) {
      stat = -1;
    }

    if (stat != -1) {
      return SizedBox(
        width: 40,
        height: 40,
        child: DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey,
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                stat > 0
                    ? stat != 2
                        ? Icons.filter_tilt_shift
                        : Icons.looks_two_rounded
                    : Icons.circle_outlined,
                size: 48,
              ),
            )),
      );
    }

    return SizedBox(
      width: 40,
      height: 40,
      child: DecoratedBox(
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(letterToShowIndex,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
          )),
    );
  }
}

class _Buttons extends ConsumerWidget {
  const _Buttons(
      {required this.players,
      required this.template,
      required this.turnKeys,
      required this.playersKeys});
  final List<PlayerDetails> players;
  final GameTemplate template;
  final List<List<GlobalKey>> turnKeys;
  final List<GlobalKey> playersKeys;
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
                      if (ref.watch(undoTreeProvider).isEmpty) {
                        return;
                      }
                      final lastAction = ref.watch(undoTreeProvider).last;
                      if (lastAction == 'broken') {
                        ref.watch(brokenpads.notifier).update((state) {
                          state -= 1;
                          return state;
                        });
                      } else {
                        final converted = lastAction as List<int>;
                        ref
                            .watch(currentPlayerProvider.notifier)
                            .update((state) {
                          state = converted[0];
                          return state;
                        });

                        ref
                            .watch(_currentRoundProvider.notifier)
                            .update((state) {
                          state = converted[1];
                          return state;
                        });
                      }
                      ref
                          .watch(listofPlayersScoresProvider.notifier)
                          .update((state) {
                        try {
                          state[ref.watch(currentPlayerProvider)]
                              .removeAt(ref.watch(_currentRoundProvider));

                          if (state[ref.watch(currentPlayerProvider)].isEmpty) {
                            state.removeAt(ref.watch(currentPlayerProvider));
                          }
                        } catch (e) {}

                        state = [...state];
                        return state;
                      });
                      ref.watch(undoTreeProvider.notifier).update((state) {
                        state.removeLast();
                        state = [...state];
                        return state;
                      });
                      return;
                    }
                    if (item == _ActionButtons.hit) {
                      int valueOfHit = template.dtl ? 3 : 1;

                      ref
                          .watch(listofPlayersScoresProvider.notifier)
                          .update((state) {
                        try {
                          // try to get user scores
                          state[ref.watch(currentPlayerProvider)]
                              .add(valueOfHit);
                        } catch (e) {
                          // player has no scores: add
                          state.add([valueOfHit]);
                        }

                        state = [...state];
                        return state;
                      });
                      ref.watch(undoTreeProvider.notifier).update((state) {
                        state.add([
                          ref.watch(currentPlayerProvider),
                          ref.watch(_currentRoundProvider)
                        ]);
                        state = [...state];

                        return state;
                      });
                      incrementRounds(ref);
                      await addAction(ref, context);
                    }
                    if (item == _ActionButtons.miss) {
                      ref
                          .watch(listofPlayersScoresProvider.notifier)
                          .update((state) {
                        try {
                          state[ref.watch(currentPlayerProvider)].add(0);
                        } catch (e) {
                          state.add([0]);
                        }

                        state = [...state];
                        return state;
                      });
                      ref.watch(undoTreeProvider.notifier).update((state) {
                        state.add([
                          ref.watch(currentPlayerProvider),
                          ref.watch(_currentRoundProvider)
                        ]);
                        state = [...state];
                        return state;
                      });
                      incrementRounds(ref);
                      await addAction(ref, context);
                    }
                    if (item == _ActionButtons.broken) {
                      ref.watch(brokenpads.notifier).update((state) {
                        state += 1;
                        return state;
                      });
                      ref.watch(undoTreeProvider.notifier).update((state) {
                        state.add('broken');
                        state = [...state];
                        return state;
                      });
                      return;
                    }

                    if (item == _ActionButtons.second) {
                      ref
                          .watch(listofPlayersScoresProvider.notifier)
                          .update((state) {
                        try {
                          state[ref.watch(currentPlayerProvider)].add(2);
                        } catch (e) {
                          state.add([2]);
                        }

                        state = [...state];
                        return state;
                      });
                      ref.watch(undoTreeProvider.notifier).update((state) {
                        state.add([
                          ref.watch(currentPlayerProvider),
                          ref.watch(_currentRoundProvider)
                        ]);
                        state = [...state];
                        return state;
                      });
                      incrementRounds(ref);
                      await addAction(ref, context);
                    }

                    if (ref.watch(roundsPlayedProvider) ==
                        (25 * players.length)) {
                      // move to game over screen
                      var scores = ref
                          .read(listofPlayersScoresProvider)
                          .map((entry) => {
                                'name': players[ref
                                        .watch(listofPlayersScoresProvider)
                                        .indexOf(entry)]
                                    .name,
                                'score': getScore(entry, template),
                                'id': players[ref
                                        .watch(listofPlayersScoresProvider)
                                        .indexOf(entry)]
                                    .id
                              })
                          .toList();
                      int hit = ref
                          .watch(listofPlayersScoresProvider)
                          .map((scores) =>
                              scores.where((score) => score > 0).length)
                          .reduce((value, element) => value + element);
                      int miss = ref
                          .watch(listofPlayersScoresProvider)
                          .map((scores) => scores
                              .where((score) => score == 0 || score == 2)
                              .length)
                          .reduce((value, element) => value + element);
                      ref.invalidate(roundsPlayedProvider);
                      ref.invalidate(undoTreeProvider);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) {
                        final session = GameSession(
                            id: const Uuid().v4(),
                            // date: ref.watch(_simuatedDate)!.toIso8601String(),
                            date: DateTime.now().toIso8601String(),
                            template: template.name,
                            hit: hit,
                            miss: miss,
                            broken: ref.read(brokenpads),
                            playersScores: scores);
                        return GameOverScreen(
                            scores: scores,
                            session: session,
                            players: players,
                            ids: players.map((e) => e.id).toList());
                      }), (route) => false);

                      resetEverything(ref);
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

  addAction(WidgetRef ref, BuildContext context) async {
    ref.watch(turnsPlayedProvider.notifier).update((state) => state + 1);
    if (ref.watch(turnsPlayedProvider) == 1) {
      ref.watch(turnsPlayedProvider.notifier).state = 0;

      if (template.compak) {
        // we are in compact mode:: move to next round with the same player
        ref.watch(_currentRoundProvider.notifier).update((state) => state + 1);

        if (ref.watch(_currentRoundProvider) % 5 == 0 &&
            (ref.watch(currentPlayerProvider) + 1) != players.length) {
          // at brreak point
          ref
              .watch(currentPlayerProvider.notifier)
              .update((state) => state + 1);

          switch (ref.watch(_currentRoundProvider)) {
            case 5:
              ref.watch(_currentRoundProvider.notifier).update((state) => 0);
            case 10:
              ref.watch(_currentRoundProvider.notifier).update((state) => 5);
            case 15:
              ref.watch(_currentRoundProvider.notifier).update((state) => 10);
            case 20:
              ref.watch(_currentRoundProvider.notifier).update((state) => 15);
            case 25:
              ref.watch(_currentRoundProvider.notifier).update((state) => 20);
          }
          await Scrollable.ensureVisible(
            turnKeys[ref.watch(currentPlayerProvider)]
                        [ref.watch(_currentRoundProvider)]
                    .currentContext ??
                context,
            duration: const Duration(
              milliseconds: 300,
            ),
          );
          return;
        }
        if ((ref.watch(currentPlayerProvider) + 1) == players.length &&
            ref.watch(_currentRoundProvider) % 5 == 0) {
          ref.watch(currentPlayerProvider.notifier).update((state) => 0);
          if (ref.watch(_currentRoundProvider) < 25) {
            await Scrollable.ensureVisible(
              turnKeys[ref.watch(currentPlayerProvider)]
                          [ref.watch(_currentRoundProvider)]
                      .currentContext ??
                  context,
              duration: const Duration(
                milliseconds: 300,
              ),
            );
          }
        }
      } else {
        if ((template.playerMovements
                    .contains(ref.watch(_currentRoundProvider)) ||
                ref.watch(_currentRoundProvider) == 24) &&
            (ref.watch(currentPlayerProvider) + 1 != players.length)) {
          template.playerMovements.sort();
          ref.watch(currentPlayerProvider.notifier).update((state) {
            state += 1;
            return state;
          });

          if (ref.watch(currentPlayerProvider) != 0) {
            await Scrollable.ensureVisible(
              playersKeys[ref.watch(currentPlayerProvider)].currentContext ??
                  context,
              duration: const Duration(milliseconds: 300),
            );
          } else {
            await Scrollable.ensureVisible(
              playersKeys[players.length == 1
                          ? 0
                          : ref.watch(currentPlayerProvider)]
                      .currentContext ??
                  context,
              duration: const Duration(milliseconds: 300),
            );
          }
          ref.watch(_currentRoundProvider.notifier).update((state) {
            try {
              var temp = template.playerMovements.indexOf(state) - 1;
              state = template.playerMovements[temp] + 1;
            } catch (e) {
              if (state == 24) {
                if (template.playerMovements.isNotEmpty) {
                  state = template.playerMovements.last + 1;
                } else {
                  state = 0;
                }
              } else {
                state = 0;
              }
            }

            return state;
          });
          await Scrollable.ensureVisible(
            turnKeys[ref.watch(currentPlayerProvider)]
                        [ref.watch(_currentRoundProvider)]
                    .currentContext ??
                context,
            duration: const Duration(
              milliseconds: 300,
            ),
          );
          return;
        } else {
          if ((template.playerMovements
                      .contains(ref.watch(_currentRoundProvider)) ||
                  ref.watch(_currentRoundProvider) == 24) &&
              (ref.watch(currentPlayerProvider) + 1 == players.length)) {
            await Scrollable.ensureVisible(
              turnKeys[0][ref.watch(_currentRoundProvider)].currentContext ??
                  context,
              duration: const Duration(
                milliseconds: 300,
              ),
            );
          }
        }
        await Scrollable.ensureVisible(
          turnKeys[ref.watch(currentPlayerProvider)]
                      [ref.watch(_currentRoundProvider)]
                  .currentContext ??
              context,
          duration: const Duration(
            milliseconds: 300,
          ),
        );

        if ((ref.watch(currentPlayerProvider) + 1 == players.length) &&
            template.playerMovements
                .contains(ref.watch(_currentRoundProvider))) {
          ref.watch(currentPlayerProvider.notifier).update((state) => 0);
        }
        ref.watch(_currentRoundProvider.notifier).update((state) => state + 1);
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
    var hitCount = player.where((e) => e == 1).length;
    var secondCount = player.where((e) => e == 0).length;
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

final turnsPlayedProvider = StateProvider.autoDispose((ref) => 0);
final _currentRoundProvider = StateProvider.autoDispose((ref) => 0);
final doubleMissProvider = StateProvider.autoDispose((ref) => 0);
final currentPlayerProvider = StateProvider.autoDispose<int>((ref) => 0);
final listofPlayersScoresProvider =
    StateProvider.autoDispose<List<List<int>>>((ref) => []);
final brokenpads = StateProvider.autoDispose((ref) => 0);
final roundsPlayedProvider = StateProvider((ref) => 0);
final undoTreeProvider = StateProvider<List<dynamic>>((ref) => []);
final _simuatedDate = StateProvider<DateTime?>((ref) => null);

int getScore(List<int> scores, GameTemplate template) {
  return scores.reduce((value, element) => value + element);
}

void resetEverything(WidgetRef ref) async {
  ref.invalidate(turnsPlayedProvider);
  ref.invalidate(_currentRoundProvider);
  ref.invalidate(doubleMissProvider);
  ref.invalidate(currentPlayerProvider);
  ref.invalidate(undoTreeProvider);
  ref.invalidate(roundsPlayedProvider);
  ref.invalidate(brokenpads);
  ref.invalidate(listofPlayersScoresProvider);
}

void incrementRounds(WidgetRef ref) {
  ref.watch(roundsPlayedProvider.notifier).update((state) {
    // Capture current state in a closure
    final currentState = state;
    return currentState + 1; // Update state
  });
}

void decrementRound(WidgetRef ref) {
  ref.watch(roundsPlayedProvider.notifier).update((state) {
    // Capture current state in a closure
    final currentState = state;
    return currentState - 1; // Update state
  });
}
