import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/models/game_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemplateStats extends ConsumerWidget {
  const TemplateStats({super.key, required this.template});
  final GameTemplate template;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text(template.name)),
        body: ref.watch(loadTemplateInfoProvider(template)).when(
            data: (sessions) {
              return SafeArea(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              title: const Text("Number of games used"),
                              subtitle: Text(sessions.length.toString())),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              title: const Text("Number of no-bird"),
                              subtitle: Text(sessions
                                  .map((e) => e.broken)
                                  .reduce((value, element) => value + element)
                                  .toString())),
                        ),
                        Column(
                          children: [
                            ...sessions.map((session) {
                              return SizedBox(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "Game ${(sessions.indexOf(session) + 1).toString()} info"),
                                      ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          title: const Text("Date"),
                                          subtitle: Text(session.date),
                                        )),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Players"),
                                      ],
                                    ),
                                    ...List.generate(
                                        session.playersScores.length, (player) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          title: Text(
                                              "Name: ${session.playersScores[player]['name'] ?? ''}"),
                                          subtitle: Text(
                                              "Score ${session.playersScores[player]['score'].toString()}"),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                              );
                            })
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            error: (er, st) {
              debugPrintStack(stackTrace: st);
              return const Center(child: Text("Error when loading data"));
            },
            loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                )));
  }
}
