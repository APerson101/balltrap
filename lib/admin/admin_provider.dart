import 'dart:convert';
import 'dart:math';

import 'package:balltrap/models/game_session.dart';
import 'package:balltrap/models/game_template.dart';
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
          config: 'faxe',
          broken: Random().nextInt(10),
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
Future addGameSession(AddGameSessionRef ref) async {
  final sessions = await ref.watch(allSessionsFakeProvider.future);
  final conn = await ref.watch(getSQLConnectionProvider.future);
  final mapped = sessions[0].toMap();
  final encodded = json.encode(mapped);
  await conn.execute(
      'INSERT INTO balltrap.sessions (id, data) VALUES (:id, :data)',
      {'id': sessions[0].id, 'data': encodded});
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
Future<List<GameTemplate>> getAllTemplates(GetAllTemplatesRef ref) async {
  final conn = await ref.watch(getSQLConnectionProvider.future);
  final result = await conn.execute('SELECT * FROM balltrap.templates');
  return result.rows
      .map((e) => GameTemplate.fromJson(e.colAt(1) ?? ""))
      .toList();
}

@riverpod
Future<MySQLConnection> getSQLConnection(GetSQLConnectionRef ref) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String ipAddr = prefs.getString('MySqlIpaddress') ?? "";
  final int port = prefs.getInt('MySqlIpPort') ?? 3306;
  final conn = await MySQLConnection.createConnection(
      host: ipAddr, port: port, userName: 'root', password: 'aaaa');
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
