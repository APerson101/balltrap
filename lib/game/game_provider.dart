import 'dart:convert';

import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/models/game_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_provider.g.dart';

@riverpod
Future<void> saveGameSession(
    SaveGameSessionRef ref, GameSession session, List<String> ids) async {
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
        "INSERT INTO balltrap.sessions_players (session_id, player_id, score) VALUES (:session_id, :player_id, :score)",
        {'session_id': session.id, 'player_id': ids[i], 'score': score});
  }
  return;
}
