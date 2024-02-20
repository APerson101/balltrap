import 'package:balltrap/game/game_screen.dart';
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
        state.add(const Uuid().v4());
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
                  ref.watch(selectedPlayersProvider.notifier).update((state) {
                    state.add(const Uuid().v4());

                    state = [...state];
                    return state;
                  });
                },
                child: const Text("test player add")),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((context) {
                    return const GameScreen();
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
                  children: ref.watch(selectedPlayersProvider).map((player) {
                return DragAndDropItem(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChoiceChip(
                      label: Text(
                          '${ref.watch(selectedPlayersProvider).indexOf(player) + 1} $player'),
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
                      selected:
                          ref.watch(selectedPlayersProvider).contains(player)),
                ));
              }).toList())
            ]));
  }
}

final selectedPlayersProvider = StateProvider((ref) => []);
final newlyScannedplayerDetails = StateProvider((ref) => {});
