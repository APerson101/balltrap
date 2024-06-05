import 'dart:convert';

import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/models/game_session.dart';
import 'package:balltrap/models/player_tag.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'game_provider.g.dart';

@riverpod
Future<void> saveGameSession(SaveGameSessionRef ref, GameSession session,
    List<String> ids, List<PlayerDetails> players) async {
  final conn = await ref.watch(getSQLConnectionProvider.future);
  await conn.execute(
      'INSERT INTO balltrap.sessions (id, data) VALUES  (:id, :data)',
      {'id': session.id, 'data': json.encode(session.toMap())});
  for (var i = 0; i < ids.length; i++) {
    int score;
    try {
      score = session.playersScores[i]['score'];
    } catch (_) {
      score = 0;
    }

    await conn.execute(
        "INSERT INTO balltrap.sessions_players (id, session_id, player_id, score) VALUES (:id, :session_id, :player_id, :score)",
        {
          'id': const Uuid().v4(),
          'session_id': session.id,
          'player_id': ids[i],
          'score': score
        });
  }

  return;
}

@riverpod
Future<void>incrementCredit(IncrementCreditRef ref,PlayerDetails player,{bool isDown=true})async{
  final conn=await ref.watch(getSQLConnectionProvider.future);
  await conn.execute(

      'UPDATE balltrap.players set subscriptionsLeft = :newNumber where id= :playerId',
      {"newNumber": player.subscriptionsLeft -= isDown?1:-1, "playerId": player.id});

}
