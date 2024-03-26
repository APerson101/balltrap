import 'package:another_flushbar/flushbar.dart';
import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/admin/game_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'add_player_details.dart';

class SummaryView extends ConsumerWidget {
  const SummaryView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
              return const Center(child: Text("Échec du chargement de l'IP"));
            },
            loading: () => const CircularProgressIndicator.adaptive()),
        const SizedBox(width: 1.0, height: 32.0),
        ...ref.watch(allSessionsProvider).when(
            data: (sessions) {
              return [
                // total games played
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: const Text("Nombre de parties jouées ce mois"),
                      tileColor: Colors.grey.shade200,
                      subtitle: Text(sessions.length.toString())),
                ),
                // broken stats
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: const Text("No-birds ce mois"),
                      tileColor: Colors.grey.shade200,
                      subtitle: Text(sessions.isNotEmpty
                          ? sessions
                              .map((each) => each.broken)
                              .reduce((value, element) => value + element)
                              .toString()
                          : '0')),
                ),
                const SizedBox(width: .0, height: 32.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      tileColor: Colors.grey.shade200,
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const CardConfigure();
                        }));
                      },
                      title: const Text("Gestion des joueurs")),
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
                    title: const Text("Gestion des templates"),
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
      ]),
    );
  }
}

class NewIP extends ConsumerWidget {
  const NewIP({super.key, this.includeId = false});
  final bool includeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        body: ref.watch(getIdsProvider(includeId)).when(
            data: (data) {
              return IPPOrtEditors(ip: data.$1 ?? "", port: data.$2.toString());
            },
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (er, st) {
              debugPrintStack(stackTrace: st);
              return const Center(
                child: Text("Error, failed to laod"),
              );
            }));
  }
}

class CardConfigure extends ConsumerWidget {
  const CardConfigure({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          children: [
            ListTile(
                title: const Text("Nouvel utilisateur"),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const AddPlayerDetails();
                  }));
                }),
            ...ref.watch(getAllPlayersProvider).when(data: (players) {
              return players.map((player) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                        title: Text(
                          player.name,
                        ),
                        subtitle: GestureDetector(
                          child: const Text("Modifier"),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return AddPlayerDetails(player: player);
                            }));
                          },
                        ),
                        trailing: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () async {
                              // remove from list\
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Delete"),
                                      content: const Text(
                                          "Supprimer le joueur?",
                                          style: TextStyle(fontSize: 20)),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              Flushbar(
                                                      title: "État",
                                                      message:
                                                          "Suppression en cours...",
                                                      duration: const Duration(
                                                          seconds: 2),
                                                      flushbarStyle:
                                                          FlushbarStyle
                                                              .FLOATING)
                                                  .show(context);
                                              // delete
                                              final result = await ref.watch(
                                                  deletePlayerProvider(player)
                                                      .future);
                                              ref.invalidate(
                                                  getAllPlayersProvider);
                                              if (result) {
                                                Flushbar(
                                                        title: "Etat",
                                                        message:
                                                            "Le joueur a été supprimé avec succès de la base de données",
                                                        duration:
                                                            const Duration(
                                                                seconds: 3),
                                                        flushbarStyle:
                                                            FlushbarStyle
                                                                .FLOATING)
                                                    .show(context);
                                              } else {
                                                Flushbar(
                                                        title: "Etat",
                                                        message:
                                                            "La suppression du joueur de la base de données a échoué.",
                                                        duration:
                                                            const Duration(
                                                                seconds: 3),
                                                        flushbarStyle:
                                                            FlushbarStyle
                                                                .FLOATING)
                                                    .show(context);
                                              }
                                              // rmeove
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("YES")),
                                        TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("NO")),
                                      ],
                                    );
                                  });
                            })),
                  ),
                );
              }).toList();
            }, loading: () {
              return [
                const Center(child: CircularProgressIndicator.adaptive())
              ];
            }, error: (er, st) {
              debugPrintStack(stackTrace: st);
              return [const Center(child: Text("Failed to load"))];
            })
          ],
        ))));
  }
}

class IPPOrtEditors extends ConsumerStatefulWidget {
  const IPPOrtEditors({Key? key, required this.ip, required this.port})
      : super(key: key);
  final String ip;
  final String port;

  @override
  _IPPOrtEditorsState createState() => _IPPOrtEditorsState();
}

class _IPPOrtEditorsState extends ConsumerState<IPPOrtEditors> {
  late TextEditingController ipcontroller;
  late TextEditingController portController;

  @override
  void initState() {
    super.initState();
    ipcontroller = TextEditingController(text: widget.ip);
    portController = TextEditingController(text: widget.port);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      controller: ipcontroller,
                      onChanged: (ip) {
                        ipcontroller.text = ip;
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
                      controller: portController,
                      // initialValue: data.$2.toString(),
                      onChanged: (ip) {
                        portController.text = ip;
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 65)),
              onPressed: () async {
                if (ipcontroller.text.isNotEmpty &&
                    portController.text.isNotEmpty) {
                  final result = await ref.watch(saveSQLIpAddressProvider(
                          ipcontroller.text, int.parse(portController.text))
                      .future);
                  if (context.mounted) {
                    if (result) {
                      Navigator.of(context).pop();
                      Flushbar(
                              title: "Etat",
                              message: "Configuration enregistrée avec succès",
                              duration: const Duration(seconds: 3),
                              flushbarStyle: FlushbarStyle.FLOATING)
                          .show(context);
                    } else {
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
    ));
  }
}
