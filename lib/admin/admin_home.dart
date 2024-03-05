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
                  title: Text(ip ?? "Aucune adresse IP trouvée"),
                  subtitle: const Text("Adresse IP de la base de données"),
                  trailing: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) {
                          return const NewIP();
                        }));
                      },
                      child: Text(ip != null
                          ? "Modifier l'adresse IP"
                          : "Définir l'adresse IP")),
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
                    title: const Text("Nombre total de parties jouées"),
                    tileColor: Colors.grey.shade200,
                    subtitle: Text(sessions.length.toString())),
              ),
              // broken stats
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text("Total cassé"),
                    tileColor: Colors.grey.shade200,
                    subtitle: Text(sessions.isNotEmpty
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
                  title: const Text("Afficher les modèles de jeu"),
                ),
              ),
            ];
          },
          loading: () =>
              [const Center(child: CircularProgressIndicator.adaptive())],
          error: (er, st) {
            debugPrintStack(stackTrace: st);
            return [
              const Center(
                  child: Text("Échec du chargement des données des joueurs"))
            ];
          })
    ]);
  }
}

final newIpAdress = StateProvider.autoDispose<String>((ref) => '');
final newIpPort = StateProvider.autoDispose<String>((ref) => '');
final deviceId = StateProvider.autoDispose<String>((ref) => '');

class NewIP extends ConsumerWidget {
  const NewIP({super.key, this.includeId = false});
  final bool includeId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Center(
          child: Column(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (ip) {
                            ref.watch(newIpAdress.notifier).state = ip;
                          },
                          decoration: InputDecoration(
                              hintText: "Entrez l'adresse IP",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (ip) {
                            ref.watch(newIpPort.notifier).state = ip;
                          },
                          decoration: InputDecoration(
                              hintText: 'Entrez le port, par exemple 3306',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            includeId
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (ip) {
                        ref.watch(deviceId.notifier).state = ip;
                      },
                      decoration: InputDecoration(
                          hintText:
                              "Entrez l'identifiant de l'appareil, par exemple 1",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 65)),
                  onPressed: () async {
                    if (ref.watch(newIpAdress).isNotEmpty &&
                        ref.watch(newIpPort).isNotEmpty) {
                      final result = await ref.watch(saveSQLIpAddressProvider(
                              ref.read(newIpAdress),
                              int.parse(ref.read(newIpPort)))
                          .future);
                      if (includeId) {
                        await ref.watch(
                            setTabletIdProvider(int.parse(ref.read(deviceId)))
                                .future);
                      }
                      if (context.mounted) {
                        if (result) {
                          Navigator.of(context).pop();
                          Flushbar(
                                  title: "Etat",
                                  message:
                                      "Configuration enregistrée avec succès",
                                  duration: const Duration(seconds: 3),
                                  flushbarStyle: FlushbarStyle.FLOATING)
                              .show(context);
                        } else {
                          print(ref.watch(newIpAdress));
                          print(ref.watch(newIpPort));
                          Flushbar(
                                  title: "Etat",
                                  message:
                                      "Échec de l'enregistrement de la nouvelle adresse IP",
                                  duration: const Duration(seconds: 3),
                                  flushbarStyle: FlushbarStyle.FLOATING)
                              .show(context);
                        }
                      }
                    } else {
                      //cannot be empty
                      Flushbar(
                              title: "Erreur",
                              message:
                                  "L'adresse IP et le port ne peuvent pas être vides...",
                              duration: const Duration(seconds: 2),
                              flushbarStyle: FlushbarStyle.FLOATING)
                          .show(context);
                    }
                  },
                  child: const Text("Enregistrer la configuration")),
            )
          ]),
        )));
  }
}
