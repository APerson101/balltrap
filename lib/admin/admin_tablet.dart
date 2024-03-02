import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/models/game_session.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TabletView extends ConsumerWidget {
  const TabletView({super.key, required this.tablet});
  final int tablet;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(allSessionsProvider).when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (er, st) {
          debugPrintStack(stackTrace: st);
          return const Center(
            child: Text("failed to load data"),
          );
        },
        data: (sessions) {
          List<GameSession> tabletSessions = sessions.isNotEmpty
              ? sessions.where((element) => element.tablet == tablet).toList()
              : [];
          return Stack(
            children: [
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                height: MediaQuery.of(context).size.height * .46,
                child: Column(
                  children: [
                    Text('Tablet $tablet'),
                    Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: const Text("Total Games Played"),
                        subtitle: Text(tabletSessions.length.toString()),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: const Text("Total Broken"),
                        subtitle: Text(tabletSessions.isNotEmpty
                            ? tabletSessions
                                .map((r) => r.broken)
                                .reduce((value, element) => value + element)
                                .toString()
                            : "0"),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                height: MediaQuery.of(context).size.height * .4,
                child: SingleChildScrollView(
                  child: Column(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text("Games Played")),
                    ),
                    ...tabletSessions.map((session) {
                      var scores = session.playersScores
                        ..sort((a, b) => b['score'].compareTo(a['score']));
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ExpansionTile(
                              title: Text((tabletSessions.indexOf(session) + 1)
                                  .toString()),
                              subtitle: Text('date: ${session.date}'),
                              children: [
                                ...scores.map((element) {
                                  return ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    title: Text(element['name']),
                                    subtitle: Text(element['score'].toString()),
                                  );
                                })
                              ]),
                        ),
                      );
                    }).toList()
                  ]),
                ),
              )
            ],
          );
        });
  }
}
