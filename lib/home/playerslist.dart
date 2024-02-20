import 'package:balltrap/game/game_screen.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayersList extends ConsumerWidget {
  const PlayersList({super.key, required this.players});
  final List players;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((context) {
                    return const GameScreen();
                  })));
                },
                child: const Text("Start"))
          ],
        ),
        body: DragAndDropLists(
            onItemReorder: (int oldItemIndex, int oldListIndex,
                int newItemIndex, int newListIndex) {},
            onListReorder: (int oldListIndex, int newListIndex) {},
            children: [
              DragAndDropList(
                  children: players.map((player) {
                return DragAndDropItem(child: Text(player.name));
              }).toList())
            ]));
  }
}
