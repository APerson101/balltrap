import 'package:another_flushbar/flushbar.dart';
import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/models/game_template.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class GameConfig extends ConsumerWidget {
  const GameConfig({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getAllTemplatesProvider).when(data: (allTemplates) {
      return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Modèles")),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        tileColor: Colors.blueAccent.shade100,
                        title: const Center(
                            child: Text("Ajouter une nouvelle configuration")),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return _ConfigAdd();
                          }));
                        }),
                  ),
                  const Divider(),
                  ...allTemplates.map((currentTemplate) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return _ViewTemplate(template: currentTemplate);
                            }));
                          },
                          leading: Text(
                              '${allTemplates.indexOf(currentTemplate) + 1}'),
                          title: Text(currentTemplate.name),
                          trailing: IconButton(
                              onPressed: () async {
                                // remove from list
                                Flushbar(
                                        title: "État",
                                        message: "Suppression en cours...",
                                        duration: const Duration(seconds: 2),
                                        flushbarStyle: FlushbarStyle.FLOATING)
                                    .show(context);
                                await ref.watch(
                                    removeTemplateProvider(currentTemplate)
                                        .future);
                                ref.invalidate(getAllTemplatesProvider);
                              },
                              icon: const Icon(Icons.cancel)),
                          subtitle:
                              Text(currentTemplate.doubleIndexes.join(', ')),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      );
    }, error: (er, st) {
      debugPrintStack(stackTrace: st);
      return const Center(
          child: Text(
              "Échec du chargement de toutes les configurations, vérifiez la connexion à la base de données"));
    }, loading: () {
      return const Center(child: CircularProgressIndicator.adaptive());
    });
  }
}

class _ConfigAdd extends ConsumerWidget {
  _ConfigAdd({this.template});
  final GameTemplate? template;
  final _letterEditingController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        persistentFooterButtons: [
          ElevatedButton(
              onPressed: () async {
                Flushbar(
                        title: "État",
                        message: "Sauvegarde en cours...:",
                        flushbarStyle: FlushbarStyle.FLOATING)
                    .show(context);
                final status = await ref.watch(addTemplateProvider(GameTemplate(
                        id: const Uuid().v4(),
                        name: ref.watch(templateNameProvider),
                        letters:
                            ref.watch(_listOfLettersProvider).values.toList(),
                        playerMovements:
                            ref.watch(listOfPlayerMovementProvider),
                        doubleIndexes: ref.watch(listOfDoubleShotsProvider),
                        dtl: false))
                    .future);
                if (context.mounted) {
                  if (status) {
                    await Flushbar(
                            title: "État",
                            message: "Ajouté avec succès à la base de données",
                            duration: const Duration(seconds: 2),
                            flushbarStyle: FlushbarStyle.FLOATING)
                        .show(context);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  } else {
                    Flushbar(
                            title: "État",
                            message: "Échec de l'ajout à la base de données",
                            duration: const Duration(seconds: 3),
                            flushbarStyle: FlushbarStyle.FLOATING)
                        .show(context);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 65)),
              child: const Text("ENREGISTRER"))
        ],
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  initialValue: template?.name,
                  onChanged: (templateName) {
                    ref.watch(templateNameProvider.notifier).state =
                        templateName;
                  },
                  decoration: InputDecoration(
                      hintText: 'Entrez le nom du modèle',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )))),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(25, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        ref.watch(_selectedCircleProvider.notifier).state =
                            index;
                        _letterEditingController.text = '';
                      },
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: ref.watch(_selectedCircleProvider) == index
                                  ? Colors.deepPurple
                                  : Colors.green,
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              ref.watch(_listOfLettersProvider)[index] ?? "-",
                              style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                  );
                })
              ],
            ),
          ),
          ref.watch(_selectedCircleProvider) != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _letterEditingController,
                    onChanged: (letter) {
                      if (letter.length > 1) return;
                      ref
                          .watch(_listOfLettersProvider.notifier)
                          .update((state) {
                        state[ref.watch(_selectedCircleProvider) ?? 0] = letter;
                        return state;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter Letter',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                )
              : Container(),
          ref.watch(_selectedCircleProvider) != null
              ? Row(
                  children: [
                    SizedBox(
                      height: 75,
                      width: MediaQuery.of(context).size.width * .5,
                      child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SwitchListTile(
                                title: const Text("Is double shot?"),
                                value: ref
                                    .watch(listOfDoubleShotsProvider)
                                    .contains(
                                        ref.watch(_selectedCircleProvider)),
                                onChanged: (switched) {
                                  if (switched) {
                                    ref
                                        .watch(
                                            listOfDoubleShotsProvider.notifier)
                                        .update((state) {
                                      state.add(
                                          ref.watch(_selectedCircleProvider) ??
                                              0);
                                      state = [...state];
                                      return state;
                                    });
                                  } else {
                                    ref
                                        .watch(
                                            listOfDoubleShotsProvider.notifier)
                                        .update((state) {
                                      state.remove(
                                          ref.watch(_selectedCircleProvider) ??
                                              0);
                                      state = [...state];
                                      return state;
                                    });
                                  }
                                })),
                      ),
                    ),
                    SizedBox(
                      height: 75,
                      width: MediaQuery.of(context).size.width * .5,
                      child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SwitchListTile(
                                title: const Text("Player moves?"),
                                value: ref
                                    .watch(listOfPlayerMovementProvider)
                                    .contains(
                                        ref.watch(_selectedCircleProvider)),
                                onChanged: (switched) {
                                  if (switched) {
                                    ref
                                        .watch(listOfPlayerMovementProvider
                                            .notifier)
                                        .update((state) {
                                      state.add(
                                          ref.watch(_selectedCircleProvider) ??
                                              0);
                                      state = [...state];
                                      return state;
                                    });
                                  } else {
                                    ref
                                        .watch(listOfPlayerMovementProvider
                                            .notifier)
                                        .update((state) {
                                      state.remove(
                                          ref.watch(_selectedCircleProvider) ??
                                              0);
                                      state = [...state];
                                      return state;
                                    });
                                  }
                                })),
                      ),
                    ),
                  ],
                )
              : Container(),
          ref.watch(listOfDoubleShotsProvider).isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: const Text('Nombre de doubles coups'),
                      subtitle: Text(ref
                          .watch(listOfDoubleShotsProvider)
                          .length
                          .toString()),
                    ),
                  ),
                )
              : Container(),
          ref.watch(listOfPlayerMovementProvider).isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: const Text('Nombre de mouvements des joueurs'),
                      subtitle: Text(ref
                          .watch(listOfPlayerMovementProvider)
                          .length
                          .toString()),
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 75,
            child: Card(
              child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SwitchListTile(
                      title: const Text("DTL?"),
                      value: ref.watch(_isDtlMode),
                      onChanged: (switched) {
                        ref.watch(_isDtlMode.notifier).state = switched;
                      })),
            ),
          ),
          SizedBox(
              height: 75,
              child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SwitchListTile(
                          title: const Text("Compak Mode?"),
                          value: ref.watch(_isCompakMode),
                          onChanged: (switched) {
                            ref.watch(_isCompakMode.notifier).state = switched;
                          }))))
        ])));
  }
}

final templateNameProvider = StateProvider((ref) => '');
final listOfDoubleShotsProvider = StateProvider<List<int>>((ref) => []);
final listOfPlayerMovementProvider = StateProvider<List<int>>((ref) => []);
final _listOfLettersProvider = StateProvider<Map<int, String>>((ref) => {});
final _selectedCircleProvider = StateProvider.autoDispose<int?>((ref) => null);
final _isDtlMode = StateProvider((ref) => false);
final _isCompakMode = StateProvider((ref) => false);

class _ViewTemplate extends ConsumerWidget {
  const _ViewTemplate({super.key, required this.template});
  final GameTemplate template;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    title: const Text("Name"), subtitle: Text(template.name))),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(25, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          ref.watch(_selectedCircleProvider.notifier).state =
                              index;
                        },
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                                color:
                                    ref.watch(_selectedCircleProvider) == index
                                        ? Colors.deepPurple
                                        : Colors.green,
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                template.letters[index],
                                style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )),
                      ),
                    );
                  })
                ],
              ),
            ),
            ref.watch(_selectedCircleProvider) != null
                ? Row(
                    children: [
                      SizedBox(
                          height: 75,
                          width: MediaQuery.of(context).size.width * .5,
                          child: Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ListTile(
                                    title: const Text("Is double shot?"),
                                    subtitle: template.doubleIndexes.contains(
                                            ref.watch(_selectedCircleProvider))
                                        ? const Text("Yes")
                                        : const Text("No"),
                                  )))),
                      SizedBox(
                        height: 75,
                        width: MediaQuery.of(context).size.width * .5,
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ListTile(
                                title: const Text("Player moves?"),
                                subtitle: template.playerMovements.contains(
                                        ref.watch(_selectedCircleProvider))
                                    ? const Text("Yes")
                                    : const Text("No"),
                              )),
                        ),
                      ),
                    ],
                  )
                : Container(),
            template.doubleIndexes.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: const Text('Nombre de doubles coups'),
                        subtitle:
                            Text(template.doubleIndexes.length.toString()),
                      ),
                    ),
                  )
                : Container(),
            template.playerMovements.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: const Text('Nombre de mouvements des joueurs'),
                        subtitle:
                            Text(template.playerMovements.length.toString()),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 75,
              child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      title: const Text("DTL?"),
                      subtitle:
                          template.dtl ? const Text("yes") : const Text("No"),
                    )),
              ),
            ),
          ]),
        )));
  }
}
