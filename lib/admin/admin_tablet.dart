import 'package:balltrap/admin/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TabletView extends ConsumerWidget {
  const TabletView({super.key, required this.tablet});
  final int tablet;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('Tablet $tablet')),
        body: ref.watch(allSessionsProvider).when(
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (er, st) {
              debugPrintStack(stackTrace: st);
              return const Center(
                child: Text("failed to load data"),
              );
            },
            data: (sessions) {
              var tabletSessions = sessions
                  .where((element) => element.tablet == tablet)
                  .toList();
              return Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 100,
                    right: 10,
                    height: MediaQuery.of(context).size.height * .3,
                    child: Column(
                      children: [
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
                            subtitle: Text(tabletSessions
                                .map((r) => r.broken)
                                .reduce((value, element) => value + element)
                                .toString()),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    left: 100,
                    right: 10,
                    bottom: 10,
                    height: MediaQuery.of(context).size.height * .5,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        ...tabletSessions.map((session) {
                          var scores = session.playersScores
                            ..sort((a, b) => b['score'].compareTo(a['score']));
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ExpansionTile(
                                title: Text(
                                    (tabletSessions.indexOf(session) + 1)
                                        .toString()),
                                subtitle: Text('date: ${session.date}'),
                                children: [
                                  ...scores.map((element) {
                                    return ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      title: Text(element['name']),
                                      subtitle:
                                          Text(element['score'].toString()),
                                    );
                                  })
                                ]),
                          );
                        }).toList()
                      ]),
                    ),
                  )
                ],
              );
            }));
  }
}
