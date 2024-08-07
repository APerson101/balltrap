import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/models/game_session.dart';
import 'package:balltrap/models/player_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerStatsView extends ConsumerWidget {
  const PlayerStatsView({super.key, required this.player});
  final PlayerDetails player;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(player.name),
        ),
        body: ref.watch(playerStatsProvider(player)).when(
            data: (stats) {
              if (stats.isEmpty) {
                return const Center(
                  child: Text(
                    "L'utilisateur n'a pas encore joué.",
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              final allTemplatesUsed = stats.map((e) => e.template).toSet();
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _SummaryView(
                        player: player,
                        stats: stats,
                      ),
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Divider(),
                            Text("Résumé des templates joués"),
                            Divider(),
                          ]),
                      ...allTemplatesUsed.map((e) {
                        final months = stats
                            .where((element) => element.template == e)
                            .map((e) => e.date.split('T')[0].substring(0, 7))
                            .toSet();

                        return Column(children: [
                          ListTile(
                              subtitle: const Text("Templates joués"),
                              title: Text(e)),
                          ...months.map((date) {
                            final monthGames = stats
                                .where((element) => element.template == e)
                                .where(
                                    (element) => element.date.contains(date));
                            return SizedBox(
                                child: Column(children: [
                              Card(
                                  child: ListTile(
                                      subtitle: const Text("Month"),
                                      title: Text(date))),
                              Card(
                                  child: ListTile(
                                      subtitle:
                                          const Text("Nombre de parties jouées"),
                                      title:
                                          Text(monthGames.length.toString())))
                            ]));
                          })
                        ]);

                        // );
                      }),
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Divider(),
                            Text("Détails des parties"),
                            Divider(),
                          ]),
                      ...stats.map((e) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(width: 1)),
                            child: Column(children: [
                              Text("Game ${stats.indexOf(e) + 1}"),
                              ListTile(
                                subtitle: const Text("score"),
                                title: Text(e.playersScores
                                    .firstWhere((element) =>
                                        element['id'] == player.id)['score']
                                    .toString()),
                              ),
                              ListTile(
                                subtitle: const Text("Date"),
                                title: Text(e.date),
                              ),
                              ListTile(
                                subtitle: const Text("Template utilisé"),
                                title: Text(e.template),
                              ),
                              ListTile(
                                subtitle: const Text("Nombre de joueurs"),
                                title: Text(e.playersScores.length.toString()),
                              )
                            ]),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
            error: (error, stackTrace) {
              debugPrintStack(stackTrace: stackTrace);
              return const Center(child: Text("Échec de chargement :(. Contactez le développeur si le problème persiste."));
            }));
  }
}

class _SummaryView extends ConsumerWidget {
  const _SummaryView({super.key,required this.player, required this.stats});
  final PlayerDetails player;
  final List<GameSession> stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: ListTile(
                    title: Text(stats.length.toString()),
                    subtitle: const Text("Nombre total de parties jouées")))),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: ListTile(
                    title: Text(stats
                        .map((e) => e.broken)
                        .reduce((value, element) => value + element)
                        .toString()),
                    subtitle: const Text("Nombre total de no-birds")))),
      ],
    );
  }
}
