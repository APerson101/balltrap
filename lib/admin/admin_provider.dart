import 'dart:convert';
import 'package:balltrap/providers/shared_providers.dart';
import 'package:balltrap/models/game_session.dart';
import 'package:balltrap/models/game_template.dart';
import 'package:balltrap/models/player_tag.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_provider.g.dart';

@riverpod
Future<List<GameSession>> allSessions(AllSessionsRef ref) async {
  try {
    final conn = await ref.watch(getSQLConnectionProvider.future);
    final result = await conn.execute('SELECT * FROM balltrap.sessions').catchError(onError(ref));
    final list =
        result.rows.map((e) => GameSession.fromJson(e.colAt(1) ?? "")).toList();
    return list;
  } catch (err) {
    return [];
  }
}
@riverpod
Future<List<GameSession>> todaySessions(TodaySessionsRef ref) async {
  try {
    final conn = await ref.watch(getSQLConnectionProvider.future);
    final result = await conn.execute('SELECT * FROM balltrap.sessions').catchError(onError(ref));
    final list =
    result.rows.map((e) => GameSession.fromJson(e.colAt(1) ?? "")).toList();
    DateTime now=DateTime.now();
    String today= "${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}";
    final list3=list.where((e)=>e.date.startsWith(today)).toList();
    return list3;
  } catch (err) {
    return [];
  }
}

@riverpod
Future<List<PlayerDetails>> playerSearch(
    PlayerSearchRef ref, String playerName) async {
  try {
    final conn = await ref.watch(getSQLConnectionProvider.future);
    final result = await conn.execute(
        "SELECT * FROM balltrap.players WHERE id LIKE :id",
        {'id': '%$playerName%'}).catchError(onError(ref));
    final list =
        result.rows.map((e) => PlayerDetails.fromMap(e.typedAssoc())).toList();
    return list;
  } catch (err) {
    return [];
  }
}

@riverpod
Future<bool> addTemplate(AddTemplateRef ref, GameTemplate template) async {
  try {
    final conn = await ref.watch(getSQLConnectionProvider.future);
    await conn.execute(
        'INSERT INTO balltrap.templates (id, templateInfo) VALUES (:id, :templateInfo)',
        {'id': template.id, 'templateInfo': json.encode(template.toMap())}).catchError(onError(ref));
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
        'DELETE FROM balltrap.templates WHERE id = :id', {'id': template.id}).catchError(onError(ref)).then((e)=>{onSuccess(ref,"Suppression OK")});
    return true;
  } catch (e) {
    return false;
  }
}

@riverpod
Future<List<PlayerDetails>> getAllPlayers(GetAllPlayersRef ref) async {
  final conn = await ref.watch(getSQLConnectionProvider.future);
  final result = await conn.execute('SELECT * FROM balltrap.players').catchError(onError(ref));
  return result.rows.map((e) => PlayerDetails.fromMap(e.typedAssoc())).toList();
}

@riverpod
Future<PlayerDetails?> getPlayer(GetPlayerRef ref, String id) async {
  final conn = await ref.watch(getSQLConnectionProvider.future);
  final result = await conn
      .execute('SELECT * FROM balltrap.players WHERE id = :id', {'id': id});
  return (result.rows
          .map((e) => PlayerDetails.fromMap(e.typedAssoc()))
          .toList())
      .firstOrNull;
}

@riverpod
Future<bool> deletePlayer(DeletePlayerRef ref, PlayerDetails player) async {
  try {
    final conn = await ref.watch(getSQLConnectionProvider.future);
    await conn.execute(
        'DELETE FROM balltrap.players WHERE id = :id', {'id': player.id}).catchError(onError(ref));
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
        }).catchError(onError(ref));
    return true;
  } catch (e) {
    return false;
  }
}

@riverpod
Future<bool> updatePlayerDetails(
    UpdatePlayerDetailsRef ref, PlayerDetails player, String? newId) async {
  try {
    final conn = await ref.watch(getSQLConnectionProvider.future);

    await conn.execute(
        "UPDATE balltrap.players SET id = :id, name = :name, subscriptionsLeft = :subs WHERE (id = :oldId)",
        {
          'id': newId ?? player.id,
          'name': player.name,
          'subs': player.subscriptionsLeft,
          "oldId": player.id
        }).catchError(onError(ref));

    return true;
  } catch (e) {
    return false;
  }
}

@riverpod
Future<List<GameTemplate>> getAllTemplates(GetAllTemplatesRef ref) async {
  final conn = await ref.watch(getSQLConnectionProvider.future);
  final result = await conn.execute('SELECT * FROM balltrap.templates').catchError(onError(ref));
  print(result.rows);
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
      {'playerId': player.id}).catchError(onError(ref));
  try {
    final sessions = sessionsData.rows
        .map((e) => GameSession.fromJson(e.colAt(1)!))
        .toList();
    return sessions;
  } catch (e) {
    return [];
  }
}

@riverpod
Future<List<GameSession>> loadTemplateInfo(
    LoadTemplateInfoRef ref, GameTemplate template) async {
  final conn = await ref.watch(getSQLConnectionProvider.future);
  final sessionsData = await conn.execute(
      '''SELECT * FROM balltrap.sessions WHERE JSON_EXTRACT(data, '\$.template') = :templateName''',
      {'templateName': template.name}).catchError(onError(ref));
  final sessions = sessionsData.rows
      .map((e) => GameSession.fromJson(e.colAt(1) ?? ""))
      .toList();
  return sessions;
}

@riverpod
Future<MySQLConnection> getSQLConnection(GetSQLConnectionRef ref) async {
  print("getting connex");
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String ipAddr = prefs.getString('MySqlIpaddress') ?? "";
  final int port = prefs.getInt('MySqlIpPort') ?? 3306;
  final conn = await MySQLConnection.createConnection(
      host: ipAddr, port: port, userName: 'ball', password: '11111111').catchError(onError(ref));
  await conn.connect(timeoutMs: 10000).catchError(onError(ref)).then((e)=>{ref.watch(mySQLErrorProvider.notifier).update("conn OK")});
  print("Conn OK");
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
    ref.invalidate(allSessionsProvider);
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
