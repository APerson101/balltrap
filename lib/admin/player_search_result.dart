import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/admin/single_player_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerSearchResult extends ConsumerWidget {
  const PlayerSearchResult({super.key, required this.playerName});
  final String playerName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Center(
                child: ref.watch(playerSearchProvider(playerName)).when(
                    data: (players) {
          if (players.isEmpty) {
            return const Center(
                child: Text("Aucun joueur portant ce nom n'a été trouvé",
                    style: TextStyle(fontSize: 25)));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ...players
                    .map((e) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading:
                                  Text((players.indexOf(e) + 1).toString()),
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return PlayerStatsView(
                                    player: e,
                                  );
                                }));
                              },
                              title: Text(e.name),
                            ),
                          ),
                        ))
                    .toList()
              ],
            ),
          );
        }, error: (er, st) {
          debugPrintStack(stackTrace: st);
          return const Center(child: Text("Failed to load names"));
        }, loading: () {
          return const Center(child: CircularProgressIndicator.adaptive());
        }))));
  }
}
