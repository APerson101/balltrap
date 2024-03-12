import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/models/player_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerStatsView extends ConsumerWidget {
  const PlayerStatsView({super.key, required this.player});
  final PlayerDetails player;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        body: ref.watch(playerStatsProvider(player)).when(
            data: (stats) {
              final allTemplatesUsed = stats.map((e) => e.template).toSet();
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                // height: 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // games played, per month, date time, points scored per game,
                      //and link to the gamne session
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              child: ListTile(
                                  title: Text(stats.length.toString()),
                                  subtitle: const Text(
                                      "Total Number of Games played")))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              child: ListTile(
                                  title: Text(stats
                                      .map((e) => e.broken)
                                      .reduce(
                                          (value, element) => value + element)
                                      .toString()),
                                  subtitle:
                                      const Text("Total Number of no-birds")))),

                      const Row(children: [
                        Expanded(child: Divider()),
                        Text("Session details"),
                        Expanded(child: Divider()),
                      ]),
                      ...allTemplatesUsed.map((e) {
                        final months = stats
                            .where((element) => element.template == e)
                            .map((e) => e.date.split('T')[0].substring(0, 7))
                            .toSet();

                        return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Column(children: [
                              ListTile(
                                  subtitle: const Text("Template Name"),
                                  title: Text(e)),
                              ...months.map((date) {
                                final monthGames = stats
                                    .where((element) => element.template == e)
                                    .where((element) =>
                                        element.date.contains(date));
                                return SizedBox(
                                    // height:
                                    //     MediaQuery.of(context).size.height,
                                    child: Expanded(
                                  child: Column(children: [
                                    Card(
                                        child: ListTile(
                                            subtitle: const Text("Date"),
                                            title: Text(date))),
                                    Card(
                                        child: ListTile(
                                            subtitle: const Text(
                                                "Number of games played"),
                                            title: Text(
                                                monthGames.length.toString())))
                                  ]),
                                ));
                              })
                            ]));
                      }),
                      const Row(children: [
                        Expanded(child: Divider()),
                        Text("Games details"),
                        Expanded(child: Divider()),
                      ]),
                      ...stats.map((e) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(width: 1)),
                              child: Column(children: [
                                Text("Game ${stats.indexOf(e) + 1}"),
                                ListTile(
                                  subtitle: const Text("score"),
                                  title: Text(e.playersScores.firstWhere(
                                      (element) =>
                                          element['id'] == player.id)['score']),
                                ),
                                ListTile(
                                  subtitle: const Text("Date"),
                                  title: Text(e.date),
                                ),
                                ListTile(
                                  subtitle: const Text("Template used"),
                                  title: Text(e.template),
                                ),
                                ListTile(
                                  subtitle: const Text("Number of players"),
                                  title:
                                      Text(e.playersScores.length.toString()),
                                )
                              ]),
                            ),
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
              return const Center(child: Text("Failed to load"));
            }));
  }
}
