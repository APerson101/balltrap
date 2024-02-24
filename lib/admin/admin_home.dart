import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/admin/game_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SummaryView extends ConsumerWidget {
  const SummaryView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: ref.watch(allSessionsProvider).when(
            data: (sessions) {
              return Column(
                children: [
                  // total games played
                  ListTile(
                      title: const Text("Total games played"),
                      subtitle: Text(sessions.length.toString())),
                  // broken stats
                  ListTile(
                      title: const Text("Total broken"),
                      subtitle: Text(sessions
                          .map((each) => each.broken)
                          .reduce((value, element) => value + element)
                          .toString())),
                  // game templates
                  ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const GameConfig();
                      }));
                    },
                    title: const Text("Show game templates"),
                  ),
                ],
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (er, st) {
              debugPrintStack(stackTrace: st);
              return const Center(child: Text("failed to load players data"));
            }));
  }
}
