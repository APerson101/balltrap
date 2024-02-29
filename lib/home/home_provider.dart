import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/models/game_template.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

@riverpod
Future<List> getPlayers(GetPlayersRef ref) async {
  return [];
}

@riverpod
Future<List<GameTemplate>> allGameTemplates(AllGameTemplatesRef ref) async {
  return await ref.watch(getAllTemplatesProvider.future);
}
