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
                        const Text("Summary"),
                        ListTile(
                          onTap: () async {
                            final range = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime.parse(sessions.first.date),
                                lastDate: DateTime.now());
                            if (range != null) {
                              ref.watch(_startDate.notifier).state =
                                  range.start;
                              ref.watch(_endDate.notifier).state = range.end;
                            }
                          },
                          title: const Text("select date range"),
                          subtitle: Text(
                              "${ref.watch(_startDate)?.toIso8601String().split("T")[0].substring(0, 7) ?? ""} - ${ref.watch(_endDate)?.toIso8601String().split("T")[0].substring(0, 7) ?? ""}"),
                        ),
                        (ref.watch(_startDate) != null &&
                                ref.watch(_endDate) != null)
                            ? ListTile(
                                title: const Text("Number of Missed"),
                                subtitle: Text(sessions
                                    .where((sesh) =>
                                        DateTime.parse(sesh.date)
                                            .isAfter(ref.watch(_startDate)!) &&
                                        DateTime.parse(sesh.date).isBefore(ref
                                            .watch(_endDate)!
                                            .add(const Duration(days: 1))))
                                    .map((e) => e.miss)
                                    .toList()
                                    .reduce((value, element) => value + element)
                                    .toString()))
                            : Container(),
                        (ref.watch(_startDate) != null &&
                                ref.watch(_endDate) != null)
                            ? ListTile(
                                title: const Text("Number of Hit"),
                                subtitle: Text(sessions
                                    .where((sesh) =>
                                        DateTime.parse(sesh.date)
                                            .isAfter(ref.watch(_startDate)!) &&
                                        DateTime.parse(sesh.date).isBefore(ref
                                            .watch(_endDate)!
                                            .add(const Duration(days: 1))))
                                    .map((e) => e.hit)
                                    .reduce((value, element) => value + element)
                                    .toString()))
                            : Container(),
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
                        const Text("Monthly stats"),
                        Column(
                          children: [
                            ...months.map((date) {
                              final monthGames = sessions.where(
                                  (element) => element.date.contains(date));
                              return SizedBox(
                                  child: Column(children: [
                                Card(
                                    child: ListTile(
                                        subtitle: const Text("Month"),
                                        title: Text(date))),
                                Card(
                                    child: ListTile(
                                        subtitle: const Text(
                                            "Number of games played"),
                                        title: Text(
                                            monthGames.length.toString()))),
                                Card(
                                    child: ListTile(
                                        subtitle:
                                            const Text("Number of no birds"),
                                        title: Text((monthGames
                                            .map((e) => e.broken)
                                            .reduce((value, element) =>
                                                value + element)).toString()))),
                              ]));
                            })
                          ],
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

final _startDate = StateProvider<DateTime?>((ref) => null);
final _endDate = StateProvider<DateTime?>((ref) => null);
