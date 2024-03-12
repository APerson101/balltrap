import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/admin/player_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerSearchResult extends ConsumerWidget {
  const PlayerSearchResult({super.key, required this.playerName});
  final String playerName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: ref.watch(playerSearchProvider(playerName)).when(
                    data: (players) {
      return SingleChildScrollView(
        child: Column(
          children: [
            ...players
                .map((e) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
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
