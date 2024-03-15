import 'dart:convert';
import 'dart:math';

import 'package:balltrap/models/game_session.dart';
import 'package:balltrap/models/game_template.dart';
import 'package:balltrap/models/player_tag.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'admin_provider.g.dart';

@riverpod
Future<List<GameSession>> allSessionsFake(AllSessionsFakeRef ref) async {
  const names = ['anita', 'marie', 'claire', 'lasagne'];
  return List.generate(
      20,
      (index) => GameSession(
          id: const Uuid().v4(),
          date: DateTime.now().toIso8601String(),
          tablet: Random().nextInt(3) + 1,
          broken: Random().nextInt(10),
          template: "test",
          playersScores: names
              .map((name) =>
                  {'name': name, 'score': Random.secure().nextInt(30)})
              .toList()));
}

@riverpod
Future<List<GameSession>> allSessions(AllSessionsRef ref) async {
  try {
    // await ref.watch(addGameSessionProvider.future);
    final conn = await ref.watch(getSQLConnectionProvider.future);
    final result = await conn.execute('SELECT * FROM balltrap.sessions');
    final list =
        result.rows.map((e) => GameSession.fromJson(e.colAt(1) ?? "")).toList();
    return list;
  } catch (err) {
    print(err);
    return [];
  }
}

@riverpod
Future<List<PlayerDetails>> playerSearch(
    PlayerSearchRef ref, String playerName) async {
  try {
    final conn = await ref.watch(getSQLConnectionProvider.future);
    final result = await conn.execute(
        "SELECT * FROM balltrap.players WHERE name LIKE :name",
        {'name': '%$playerName%'});
    final list =
        result.rows.map((e) => PlayerDetails.fromMap(e.typedAssoc())).toList();
    return list;
  } catch (err) {
    return [];
  }
}

@riverpod
Future addGameSession(AddGameSessionRef ref, GameSession session) async {
  final conn = await ref.watch(getSQLConnectionProvider.future);
  final mapped = session.toMap();
  final encodded = json.encode(mapped);
  await conn.execute(
      'INSERT INTO balltrap.sessions (id, data) VALUES (:id, :data)',
      {'id': session.id, 'data': encodded});
  await conn.execute(
      'INSERT INTO balltrap.sessions_players (session_id, player_id, score) VALUES (:session, :player, :score)',
      {'session': session.id, 'player': 'first', 'score': 40});
  // ref.invalidate(allSessionsProvider);
}

@riverpod
Future<bool> addTemplate(AddTemplateRef ref, GameTemplate template) async {
  try {
    final conn = await ref.watch(getSQLConnectionProvider.future);
    await conn.execute(
        'INSERT INTO balltrap.templates (id, templateInfo) VALUES (:id, :templateInfo)',
        {'id': template.id, 'templateInfo': json.encode(template.toMap())});
    ref.invalidate(getAllTemplatesProvider);
    return true;
  } catch (e) {
    return false;
  }
}

@riverpod
Future<bool> removeTemplate(
    RemoveTemplateRef ref, GameTemplate template) async {
  try {
    final conn = await ref.watch(getSQLConnectionProvider.future);
    await conn.execute(
        'DELETE FROM balltrap.templates WHERE id = :id', {'id': template.id});
    return true;
  } catch (e) {
    return false;
  }
}

@riverpod
Future<List<PlayerDetails>> getAllPlayers(GetAllPlayersRef ref) async {
  final conn = await ref.watch(getSQLConnectionProvider.future);
  final result = await conn.execute('SELECT * FROM balltrap.players');
  return result.rows.map((e) => PlayerDetails.fromMap(e.typedAssoc())).toList();
}

@riverpod
Future<bool> deletePlayer(DeletePlayerRef ref, PlayerDetails player) async {
  try {
    final conn = await ref.watch(getSQLConnectionProvider.future);
    await conn.execute(
        'DELETE FROM balltrap.players WHERE id = :id', {'id': player.id});
    return true;
  } catch (e) {
    return false;
  }
}

@riverpod
Future<bool> savePlayerDetails(
    SavePlayerDetailsRef ref, PlayerDetails player) async {
  try {
    final conn = await ref.watch(getSQLConnectionProvider.future);
    await conn.execute(
        'INSERT INTO balltrap.players (id, name, subscriptionsLeft) VALUES (:id, :name, :subs)',
        {
          'id': player.id,
          'name': player.name,
          'subs': player.subscriptionsLeft
        });
    return true;
  } catch (e) {
    return false;
  }
}

@riverpod
Future<List<GameTemplate>> getAllTemplates(GetAllTemplatesRef ref) async {
  final conn = await ref.watch(getSQLConnectionProvider.future);
  final result = await conn.execute('SELECT * FROM balltrap.templates');
  return result.rows
      .map((e) => GameTemplate.fromJson(e.colAt(1) ?? ""))
      .toList();
}

@riverpod
Future<List<GameSession>> playerStats(
    PlayerStatsRef ref, PlayerDetails player) async {
  final conn = await ref.watch(getSQLConnectionProvider.future);
  final sessionsData = await conn.execute(
      'SELECT * FROM balltrap.sessions JOIN balltrap.sessions_players ON sessions_players.session_id = sessions.id WHERE sessions_players.player_id = :playerId',
      {'playerId': player.id});
  final sessions = sessionsData.rows
      .map((e) => GameSession.fromJson(e.colAt(1) ?? ""))
      .toList();
  return sessions;
}

@riverpod
Future<List<GameSession>> loadTemplateInfo(
    LoadTemplateInfoRef ref, GameTemplate template) async {
  final conn = await ref.watch(getSQLConnectionProvider.future);
  final sessionsData = await conn.execute(
      '''SELECT * FROM balltrap.sessions WHERE JSON_EXTRACT(data, '\$.template') = :templateName''',
      {'templateName': template.name});
  final sessions = sessionsData.rows
      .map((e) => GameSession.fromJson(e.colAt(1) ?? ""))
      .toList();
  return sessions;
}

@riverpod
Future<MySQLConnection> getSQLConnection(GetSQLConnectionRef ref) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String ipAddr = prefs.getString('MySqlIpaddress') ?? "";
  final int port = prefs.getInt('MySqlIpPort') ?? 3306;
  final conn = await MySQLConnection.createConnection(
      host: ipAddr, port: port, userName: 'root', password: '11111111');
  await conn.connect(timeoutMs: 5000);
  return conn;
}

@riverpod
Future<bool> saveSQLIpAddress(
    SaveSQLIpAddressRef ref, String ip, int port) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('MySqlIpaddress', ip);
    await prefs.setInt('MySqlIpPort', port);
    ref.invalidate(getIpAddressProvider);
    return true;
  } catch (er) {
    return false;
  }
}

@riverpod
Future<String?> getIpAddress(GetIpAddressRef ref) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final ip = prefs.getString('MySqlIpaddress');
  final port = prefs.getInt('MySqlIpPort');
  return '${ip ?? ""} : ${port ?? ""}';
}

@riverpod
Future<(String?, int?, int?)> getIds(GetIdsRef ref, bool deviceID) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final ip = prefs.getString('MySqlIpaddress');
  final port = prefs.getInt('MySqlIpPort');
  int? tId;
  if (deviceID) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    tId = prefs.getInt('TabletId');
  }
  return (ip, port, tId);
}

@riverpod
Future<int?> getIpPort(GetIpPortRef ref) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('MySqlIpPort');
}

@riverpod
Future<int?> getTabletId(GetTabletIdRef ref) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('TabletId');
}

@riverpod
Future<void> setTabletId(SetTabletIdRef ref, int id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('TabletId', id);
}

@riverpod
Future<dynamic> test(TestRef ref) async {
// create new game sessions, save to sessions db and save to sessions_players DB
  // final players = await ref.watch(getAllPlayersProvider.future);

  // create new template

  final newTemplate = GameTemplate(
      name: "test 3",
      dtl: false,
      letters: List.generate(25, (index) => 'A'),
      playerMovements: [3, 10],
      doubleIndexes: [],
      compak: false,
      id: const Uuid().v4());
  await ref.watch(addTemplateProvider(newTemplate).future);
  return;
  final sessionId = const Uuid().v4();
  final newGame = GameSession(
      id: sessionId,
      date: DateTime.now().toIso8601String(),
      template: 'test 1',
      tablet: 1,
      broken: 20,
      playersScores: [
        {'name': 'abdul', "id": "first", "score": "40"},
        {'name': 'baba', "id": "second", "score": "80"},
        {'name': 'abdul', "id": "third", "score": "50"}
      ]);
  await ref.watch(addGameSessionProvider(newGame).future);
  // await ref.watch(savePlayerDetailsProvider(PlayerDetails(
  //         id: const Uuid().v4(), name: "name", subscriptionsLeft: 10))
  //     .future);
  // print('Testing player retreival: ');
  // final newList = await ref.watch(getAllPlayersProvider.future);
  // print(newList);
  return true;
}
