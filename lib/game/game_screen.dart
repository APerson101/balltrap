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
    return PopScope(child:
       Scaffold(
          appBar: AppBar(
            title: _CurrentPlayer(players: players, template: template),
            centerTitle:true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () async {
                      var scores = ref
                          .read(listOfPlayersScoresProvider)
                          .map((entry) => {
                        'name': players[ref
                            .read(listOfPlayersScoresProvider)
                            .indexOf(entry)]
                            .name,
                        'score': getScore(entry, template),
                        'id': players[ref
                            .watch(listOfPlayersScoresProvider)
                            .indexOf(entry)]
                            .id
                      })
                          .toList();
                      int hit = ref
                          .read(listOfPlayersScoresProvider)
                          .map((scores) =>
                      scores.where((score) => score > 0).length)
                          .reduce((value, element) => value + element);
                      int miss = ref
                          .read(listOfPlayersScoresProvider)
                          .map((scores) => scores
                          .where((score) => score == 0 || score == 2)
                          .length)
                          .reduce((value, element) => value + element);
                      int broken = ref.read(brokenPads);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        final session = GameSession(
                            id: const Uuid().v4(),
                            hit: hit,
                            miss: miss,
                            template: template.name,
                            date: DateTime.now().toIso8601String(),
                            broken: broken,
                            playersScores: scores);
                        return GameOverScreen(
                            scores: scores,
                            session: session,
                            players: players,
                            ids: players.map((e) => e.id).toList());
                      }));
                    },
                    child: const Text("Terminé",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("No-bird: ${ref.watch(brokenPads)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              )
            ],
          ),
          body: SafeArea(
            child: Column(children: [
              Container(
                height:MediaQuery.of(context).size.height*0.7,
              child:_ScoreCards(
                      players: players,
                      template: template,
                      turnKeys: ballKeys,
                      playerKeys: playersKeys)),
              Expanded(

                  child: _Buttons(
                    players: players,
                    template: template,
                    playersKeys: playersKeys,
                    turnKeys: ballKeys,
                  )),
            ]),
          )
      )
    ) ;
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
    return
       Column(
          children: List.generate(players.length, (index) {
            var scores = ref.watch(listOfPlayersScoresProvider);
            List<int> player;
            try {
              player = scores[index];
            } catch (_) {
              player = List.generate(25, (index) => 0);
            }
            var score = player.reduce((value, element) => value + element);
            var score2 = player.map((e)=>e==0?0:1).reduce((value,element)=>value+element);
            return Padding(
              key: playerKeys[index],
              padding: const EdgeInsets.all(1.0),
              child: Card(
                child: Row(
                  children: [
                     SizedBox(
                       height:50,
                      width:100,
                      child: Text(players[index].name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),

Expanded(
        child:              Row(
                          children: List.generate(25, (boxIndex) {
                            if (template.doublesCDF.contains(boxIndex - 1)||template.doublesSim.contains(boxIndex-1)) {
                              return Container();
                            }

                            if (template.doublesCDF.contains(boxIndex)||template.doublesSim.contains(boxIndex)) {
                              return Padding(
                                key: turnKeys[index][boxIndex],
                                padding: EdgeInsets.only(
                                    right: (template.playerMovements
                                        .contains(boxIndex + 1) &&
                                        !template.compak) ||
                                        (template.compak && (boxIndex + 2) % 5 == 0)
                                        ? 20
                                        : 3),
                                child: SizedBox(
                                  width: 50,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        color:template.doublesSim.contains(boxIndex)? Colors.blueAccent:Colors.amberAccent,
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
                                                  currentBox: boxIndex,
                                                  template: template,
                                                  letters: template.letters,
                                                )),
                                            DecoratedBox(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(20)),
                                                child: _BoxIcon(
                                                  currentPlayer: index,
                                                  currentBox: boxIndex + 1,
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
                                key: turnKeys[index][boxIndex],
                                padding: EdgeInsets.only(
                                    right: template.playerMovements
                                        .contains(boxIndex) ||
                                        (template.compak && (boxIndex + 1) % 5 == 0)
                                        ? 20
                                        : 3),
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20)),
                                    child: _BoxIcon(
                                        currentPlayer: index,
                                        currentBox: boxIndex,
                                        template: template,
                                        letters: template.letters)));
                          })
                      ))
,
                    Text(
                      template.dtl ? '$score/75 $score2/25' : '$score/25',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ]),
              ),
            );
          }),
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
        height: 22,
        width: 22,
        child: DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple,
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(letterToShowIndex,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24)),
            )),
      );
    }
    List<int> playerScores;
    int stat;

    try {
      playerScores = ref.watch(listOfPlayersScoresProvider)[currentPlayer];
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
        width: 22,
        height: 22,
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
                size: 24,
              ),
            )),
      );
    }

    return SizedBox(
      width: 22,
      height: 22,
      child: DecoratedBox(
          decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(letterToShowIndex,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
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
                padding:const EdgeInsets.all(8),
                child:
                GestureDetector(
                  onTap: () async {
                    if (item == _ActionButtons.undo) {
                      if (ref.watch(undoTreeProvider).isEmpty) {
                        return;
                      }
                      final lastAction = ref.watch(undoTreeProvider).last;
                      if (lastAction == 'broken') {
                        ref.watch(brokenPads.notifier).update((state) {
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
                          .watch(listOfPlayersScoresProvider.notifier)
                          .update((state) {
                        try {
                          state[ref.watch(currentPlayerProvider)]
                              .removeAt(ref.watch(_currentRoundProvider));

                          if (state[ref.watch(currentPlayerProvider)].isEmpty) {
                            state.removeAt(ref.watch(currentPlayerProvider));
                          }
                        } catch (e) {
                              print(e);
                        }

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
                          .watch(listOfPlayersScoresProvider.notifier)
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
                          .watch(listOfPlayersScoresProvider.notifier)
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
                      if (context.mounted) {
                        await addAction(ref, context);
                      }
                    }
                    if (item == _ActionButtons.broken) {
                      ref.watch(brokenPads.notifier).update((state) {
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
                          .watch(listOfPlayersScoresProvider.notifier)
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
                      if (context.mounted) {
                        await addAction(ref, context);
                      }
                    }

                    if (ref.watch(roundsPlayedProvider) ==
                        (25 * players.length)) {
                      // move to game over screen
                      var scores = ref
                          .read(listOfPlayersScoresProvider)
                          .map((entry) => {
                        'name': players[ref
                            .watch(listOfPlayersScoresProvider)
                            .indexOf(entry)]
                            .name,
                        'score': getScore(entry, template),
                        'id': players[ref
                            .watch(listOfPlayersScoresProvider)
                            .indexOf(entry)]
                            .id
                      })
                          .toList();
                      int hit = ref
                          .watch(listOfPlayersScoresProvider)
                          .map((scores) =>
                      scores.where((score) => score > 0).length)
                          .reduce((value, element) => value + element);
                      int miss = ref
                          .watch(listOfPlayersScoresProvider)
                          .map((scores) => scores
                          .where((score) => score == 0 || score == 2)
                          .length)
                          .reduce((value, element) => value + element);
                      ref.invalidate(roundsPlayedProvider);
                      ref.invalidate(undoTreeProvider);
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                              final session = GameSession(
                                  id: const Uuid().v4(),
                                  date: DateTime.now().toIso8601String(),
                                  template: template.name,
                                  hit: hit,
                                  miss: miss,
                                  broken: ref.read(brokenPads),
                                  playersScores: scores);
                              return GameOverScreen(
                                  scores: scores,
                                  session: session,
                                  players: players,
                                  ids: players.map((e) => e.id).toList());
                            }), (route) => false);
                      }
                      resetEverything(ref);
                    }
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: BorderRadius.circular(20)),
                      child:
                   Padding(
                      padding: const EdgeInsets.only(
                          left: 2.0, right: 2.0, top: 10, bottom: 10),
                      child:Column(
                      children:  [Icon(item.iconData),

                        Text(item.label.toUpperCase())
                  ])
                    ))
                  ),
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
          // at break point
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
  const ScoreCalculator( this.is25,{super.key, required this.index});
  final int index;
  final bool is25;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var player = ref.watch(listOfPlayersScoresProvider)[index];
    var hitCount = player.where((e) => e == 1).length;
    var secondCount = player.where((e) => e == 0).length;
    var score = ((3 * hitCount) + (2 * secondCount));
    if(!is25) {
      return Text(score.toString());
    }
    else{
      return Text(hitCount.toString());
    }
  }
}

enum _ActionButtons {
  broken(
      label: 'no-bird', iconData: Icons.broken_image, color: Color(0xffffffff)),
  undo(label: 'annuler', iconData: Icons.undo, color: Color(0xffffffff)),
  miss(
      label: "miss", iconData: Icons.circle_outlined, color: Color(0xffD37676)),

  second(
      label: "second",
      iconData: Icons.looks_two_rounded,
      color: Color(0xffEBC49F)),
  hit(
      label: "hit",
      iconData: Icons.filter_tilt_shift,
      color: Color(0xffB0C5A4));

  const _ActionButtons(
      {required this.label, required this.iconData, required this.color});
  final String label;
  final Color color;
  final IconData iconData;
}

final turnsPlayedProvider = StateProvider.autoDispose((ref) => 0);
final _currentRoundProvider = StateProvider.autoDispose((ref) => 0);
final doubleMissProvider = StateProvider.autoDispose((ref) => 0);
final currentPlayerProvider = StateProvider.autoDispose<int>((ref) => 0);
final listOfPlayersScoresProvider =
StateProvider.autoDispose<List<List<int>>>((ref) => []);
final brokenPads = StateProvider.autoDispose((ref) => 0);
final roundsPlayedProvider = StateProvider((ref) => 0);
final undoTreeProvider = StateProvider<List<dynamic>>((ref) => []);

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
  ref.invalidate(brokenPads);
  ref.invalidate(listOfPlayersScoresProvider);
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