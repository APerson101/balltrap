import 'dart:math';

import 'package:balltrap/models/game_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'admin_provider.g.dart';

@riverpod
Future<List<GameSession>> allSessions(AllSessionsRef ref) async {
  const names = ['anita', 'marie', 'claire', 'lasagne'];
  return List.generate(
      20,
      (index) => GameSession(
          id: const Uuid().v4(),
          date: DateTime.now().toIso8601String(),
          tablet: Random().nextInt(3) + 1,
          broken: Random().nextInt(10),
          playersScores: names
              .map((name) =>
                  {'name': name, 'score': Random.secure().nextInt(30)})
              .toList()));
}
