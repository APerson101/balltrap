import 'dart:convert';

import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/models/game_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_provider.g.dart';

@riverpod
Future<void> saveGameSession(
    SaveGameSessionRef ref, GameSession session) async {
  final conn = await ref.watch(getSQLConnectionProvider.future);
  await conn.execute(
      'INSERT INTO balltrap.sessions (id, data) VALUES  (:id, :data)',
      {'id': session.id, 'data': json.encode(session.toMap())});
  return;
}
