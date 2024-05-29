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
              if (sessions.isEmpty) {
                return const Center(
                    child: Text("Modèle pas encore utilisé",
                        style: TextStyle(fontSize: 25)));
              }
              final months = sessions
                  .map((e) => e.date.split('T')[0].substring(0, 7))
                  .toSet();
              return SafeArea(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text("Stats Mensuels"),
                        Column(
                          children: [
                            ...months.map((date) {
                              final monthGames = sessions.where(
                                  (element) => element.date.contains(date));
                              return SizedBox(
                                  child: Column(children: [
                                Card(
                                    child: ListTile(
                                        subtitle: const Text("Mois"),
                                        title: Text(date))),
                                Card(
                                    child: ListTile(
                                        subtitle: const Text(
                                            "Nombre de parties jouées"),
                                        title: Text(
                                            monthGames.length.toString()))),
                                Card(
                                    child: ListTile(
                                        subtitle:
                                            const Text("Nombre de no-birds"),
                                        title: Text((monthGames
                                            .map((e) => e.broken)
                                            .reduce((value, element) =>
                                                value + element)).toString()))),
                              ]));
                            })
                          ],
                        ),
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

