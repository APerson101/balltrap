import 'dart:math';

import 'package:balltrap/game/game_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_provider.g.dart';

typedef PlayerData = ({String name, String id, int startingStation});
@riverpod
Future<List<PlayerData>> getSessionPlayers(GetSessionPlayersRef ref) async {
  var players = ref.watch(listofPlayersScoresProvider);
  var names = ['anna', 'eric', 'abidal', 'henry'];
  return List.generate(4, (index) {
    var player = (
      name: names[index],
      id: "42311",
      startingStation: [1, 2][Random.secure().nextInt(2)]
    );
    players.addAll({'$index': []});
    ref.watch(sessionScoresProvider).add(0);
    return player;
  });
}
