import 'package:another_flushbar/flushbar.dart';
import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/admin/game_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SummaryView extends ConsumerWidget {
  const SummaryView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ref.watch(getIpAddressProvider).when(
          data: (ip) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text(ip ?? "no ip found"),
                  subtitle: const Text("Database Ip address"),
                  trailing: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) {
                          return const _NewIP();
                        }));
                      },
                      child: Text(ip != null ? "Change ip" : "Set IP Address")),
                ),
              ),
          error: (er, st) {
            debugPrintStack(stackTrace: st);
            return const Center(child: Text("Failed to load ip address"));
          },
          loading: () => const CircularProgressIndicator.adaptive()),
      ...ref.watch(allSessionsProvider).when(
          data: (sessions) {
            return [
              // total games played
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text("Total games played"),
                    tileColor: Colors.grey.shade200,
                    subtitle: Text(sessions.length.toString())),
              ),
              // broken stats
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text("Total broken"),
                    tileColor: Colors.grey.shade200,
                    subtitle: Text(sessions.length > 0
                        ? sessions
                            .map((each) => each.broken)
                            .reduce((value, element) => value + element)
                            .toString()
                        : '0')),
              ),
              // game templates
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  tileColor: Colors.grey.shade200,
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const GameConfig();
                    }));
                  },
                  title: const Text("Show game templates"),
                ),
              ),
            ];
          },
          loading: () =>
              [const Center(child: CircularProgressIndicator.adaptive())],
          error: (er, st) {
            debugPrintStack(stackTrace: st);
            return [const Center(child: Text("failed to load players data"))];
          })
    ]);
  }
}

final newIpAdress = StateProvider.autoDispose<String>((ref) => '');

class _NewIP extends ConsumerWidget {
  const _NewIP();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Center(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (ip) {
                  ref.watch(newIpAdress.notifier).state = ip;
                },
                decoration: InputDecoration(
                    hintText: 'Enter ip address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 65)),
                  onPressed: () async {
                    if (ref.watch(newIpAdress).isNotEmpty) {
                      final result = await ref.watch(
                          saveSQLIpAddressProvider(ref.read(newIpAdress))
                              .future);
                      if (context.mounted) {
                        if (result) {
                          Navigator.of(context).pop();
                          Flushbar(
                                  title: "Status",
                                  message: "Sucessfully saved new ip address",
                                  duration: const Duration(seconds: 3),
                                  flushbarStyle: FlushbarStyle.FLOATING)
                              .show(context);
                        } else {
                          Flushbar(
                                  title: "Status",
                                  message: "Failed to save new ip address",
                                  duration: const Duration(seconds: 3),
                                  flushbarStyle: FlushbarStyle.FLOATING)
                              .show(context);
                        }
                      }
                    } else {
                      //cannot be empty
                      Flushbar(
                              title: "Error",
                              message: "ip address cannot be empty....",
                              duration: const Duration(seconds: 2),
                              flushbarStyle: FlushbarStyle.FLOATING)
                          .show(context);
                    }
                  },
                  child: const Text("Save new ip address")),
            )
          ]),
        )));
  }
}
