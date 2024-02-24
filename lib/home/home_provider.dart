import 'dart:math';

import 'package:balltrap/models/game_template.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

@riverpod
Future<List> getPlayers(GetPlayersRef ref) async {
  return [];
}

@riverpod
Future<List<GameTemplate>> allGameTemplates(AllGameTemplatesRef ref) async {
  return ['test 1 ', 'test 2', 'test 3'].map((each) {
    return GameTemplate(name: each, doubleIndexes: [
      ...[Random().nextInt(25), Random().nextInt(25), Random().nextInt(25)]
    ]);
  }).toList();
}
