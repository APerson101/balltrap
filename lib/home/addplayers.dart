import 'package:balltrap/game/game_screen.dart';
import 'package:balltrap/home/home_provider.dart';
import 'package:balltrap/models/player_tag.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:uuid/uuid.dart';

class AddPlayers extends ConsumerWidget {
  const AddPlayers({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NfcManager.instance.startSession(onDiscovered: (tag) async {
      ref.watch(selectedPlayersProvider.notifier).update((state) {
        state.add(PlayerDetails(id: const Uuid().v4(), name: tag.data['name']));
        state = [...state];
        return state;
      });
      // ignore: avoid_print
      print(tag.data);
    });
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  var names = [
                    'kylian',
                    "Antoine",
                    "Marie",
                    "Claire",
                    "Lascary",
                    "Paul"
                  ];
                  ref.watch(selectedPlayersProvider.notifier).update((state) {
                    state.add(PlayerDetails(
                        id: const Uuid().v4(), name: names[state.length]));
                    state = [...state];
                    return state;
                  });
                },
                child: const Text("Add Player")),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((context) {
                    return const _GameTypeConfirmation();
                  })));
                },
                child: const Text("Next"))
          ],
        ),
        body: DragAndDropLists(
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
                  contentsWhenEmpty: const Center(
                      child: Text("No players added yet, tap card to add")),
                  children: ref.watch(selectedPlayersProvider).map((player) {
                    return DragAndDropItem(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChoiceChip(
                          label: ListTile(
                            title: Text(player.name),
                            leading: Text(
                                '${ref.watch(selectedPlayersProvider).indexOf(player) + 1}'),
                            subtitle: Text(player.id),
                          ),
                          onSelected: (selected) {
                            ref
                                .watch(selectedPlayersProvider.notifier)
                                .update((state) {
                              if (state.contains(player)) {
                                state.remove(player);
                              } else {
                                state.add(player);
                              }
                              state = [...state];
                              return state;
                            });
                          },
                          selected: ref
                              .watch(selectedPlayersProvider)
                              .contains(player)),
                    ));
                  }).toList())
            ]));
  }
}

final selectedPlayersProvider = StateProvider<List<PlayerDetails>>((ref) => []);
final newlyScannedplayerDetails = StateProvider((ref) => {});

class _GameTypeConfirmation extends ConsumerWidget {
  const _GameTypeConfirmation();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(allGameTemplatesProvider).when(data: (allTemplates) {
      return Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return GameScreen(
                          template: allTemplates[
                              ref.read(_selectedTemplateProvider)]);
                    }));
                  },
                  child: const Text("Start"))
            ],
          ),
          body: SingleChildScrollView(
              child: Column(children: [
            ...allTemplates.map((template) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    tileColor: ref.watch(_selectedTemplateProvider) ==
                            allTemplates.indexOf(template)
                        ? Colors.purpleAccent
                        : null,
                    title: Text(template.name),
                    subtitle: Text(template.doubleIndexes.join(', ')),
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

final _selectedTemplateProvider = StateProvider((ref) => 0);
