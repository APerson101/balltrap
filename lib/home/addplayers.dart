
import 'package:another_flushbar/flushbar.dart';
import 'package:balltrap/game/game_provider.dart';
import 'package:balltrap/game/game_screen.dart';
import 'package:balltrap/home/home_provider.dart';
import 'package:balltrap/models/player_tag.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddPlayers extends ConsumerWidget {
  AddPlayers({super.key, required this.players});
  final List<PlayerDetails> players;
  final TextEditingController _controller=TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .4,
                height: 60,
                child: TextFormField(
                  controller:_controller,
                  onChanged: (id) async {
                    final pl = players.firstWhere((element) => element.id == id,
                        orElse: () => PlayerDetails(
                            id: '-1', name: '', subscriptionsLeft: 0));
                    if (pl.id != "-1") {
                      if (ref.watch(selectedPlayersProvider).length == 6) {
                        await Flushbar(
                          title: "Alerte",
                          message: "Nombre maximum de joueurs atteint.",
                          duration: const Duration(seconds: 2),
                        ).show(context);
                        _controller.clear();
                        return;
                      }
                      if(pl.subscriptionsLeft<1){
                       await Flushbar(
                         title: "Alerte",
                         message:"Plus de crédit",
                         duration:const Duration(seconds:2)
                       ).show(context);
                       _controller.clear();
                        return;}
                      ref
                          .watch(selectedPlayersProvider.notifier)
                          .update((state) {
                        state.add(pl);
                        state = [...state];
                        _controller.clear();
                        ref.watch(incrementCredit(ref, pl));
                        return state;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
            ),

            TextButton(
                onPressed: () {
                  if (ref.watch(selectedPlayersProvider).isNotEmpty) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: ((context) {
                      return const _GameTypeConfirmation();
                    })));
                  }
                },
                child: const Text("Suivant",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)))
          ],
        ),
        body: DragAndDropLists(
            lastItemTargetHeight: 149,
            onItemReorder: (int oldItemIndex, int oldListIndex,
                int newItemIndex, int newListIndex) {
              ref.watch(selectedPlayersProvider.notifier).update((state) {
                state.insert(newItemIndex, state[oldItemIndex]);
                if (oldItemIndex < newItemIndex) {
                  var tem = state[newItemIndex + 1];
                  state[newItemIndex + 1] = state[newItemIndex];
                  state[newItemIndex] = tem;
                }
                state.removeAt(oldItemIndex > newItemIndex
                    ? oldItemIndex + 1
                    : oldItemIndex);
                state = [...state];
                return state;
              });
            },
            onListReorder: (int oldListIndex, int newListIndex) {},
            children: [
              DragAndDropList(
                  verticalAlignment: CrossAxisAlignment.center,
                  horizontalAlignment: MainAxisAlignment.center,
                  contentsWhenEmpty: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .2, left: 20),
                    child: const Center(
                        child: Text(
                            "Pour ajouter un joueur, tapez sur la barre de texte puis scannez la carte.",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold))),
                  ),
                  children: ref.watch(selectedPlayersProvider).map((player) {
                    return DragAndDropItem(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                          child: ChoiceChip(
                              selectedColor: const Color.fromRGBO(241, 239, 153, 1),
                              label: ListTile(
                                  title: Text(player.name,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  leading: Text(
                                      '${ref.watch(selectedPlayersProvider).indexOf(player) + 1}',
                                      style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(player.id,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  trailing: Text(
                                    "${player.subscriptionsLeft<6?'Peu restant':'Restant'}: ${player.subscriptionsLeft}",
                                    style: TextStyle(
                                        color: player.subscriptionsLeft <= 5
                                            ? Colors.red
                                            : Colors.black,
                                        fontSize: 20),
                                  )),
                              onSelected: (selected) async {
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: const Text("Suppr ?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                ref
                                                    .watch(selectedPlayersProvider
                                                    .notifier)
                                                    .update((state) {
                                                  if (state.contains(player)) {
                                                    state.remove(player);
                                                  } else {
                                                    state.add(player);
                                                  }
                                                  state = [...state];
            ref.watch(incrementCreditProvider(ref, player,{isDown=true}));
                                                  return state;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("oui")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("non"))
                                        ],
                                      );
                                    });
                              },
                              selected: ref
                                  .watch(selectedPlayersProvider)
                                  .contains(player)),
                    ));
                  }).toList()),
            ]));
  }
}

final selectedPlayersProvider =
    StateProvider.autoDispose<List<PlayerDetails>>((ref) => []);
final newlyScannedplayerDetails = StateProvider.autoDispose((ref) => {});

class _GameTypeConfirmation extends ConsumerWidget {
  const _GameTypeConfirmation();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(allGameTemplatesProvider).when(data: (allTemplates) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Sélectionnez le template",
                style: TextStyle(
                  fontSize: 20,
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      final temp =
                          allTemplates[ref.read(_selectedTemplateProvider)];
                      final players = ref.read(selectedPlayersProvider);

                      return GameScreen(players: players, template: temp);
                    }));
                  },
                  child: const Text("Démarrer",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
            ],
          ),
          body: SingleChildScrollView(
              child: Column(children: [
            ...allTemplates.map((template) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: Text(
                        (allTemplates.indexOf(template) + 1).toString(),
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    tileColor: ref.watch(_selectedTemplateProvider) ==
                            allTemplates.indexOf(template)
                        ? const Color.fromRGBO(241, 239, 153, 1)
                        : null,
                    title: Text(template.name,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    onTap: () {
                      ref.watch(_selectedTemplateProvider.notifier).state =
                          allTemplates.indexOf(template);
                    },
                  ),
                ),
              );
            })
          ])));
    }, loading: () {
      return const Center(child: CircularProgressIndicator.adaptive());
    }, error: (er, st) {
      debugPrintStack(stackTrace: st);
      return const Center(
        child: Text("Failed to load templates data"),
      );
    });
  }
}

final _selectedTemplateProvider = StateProvider.autoDispose((ref) => 0);

// one player
