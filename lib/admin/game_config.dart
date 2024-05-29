import 'package:another_flushbar/flushbar.dart';
import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/admin/template_stats.dart';
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
        appBar: AppBar(centerTitle: true, title: const Text("Templates")),
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
                                // remove from list\
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Suppr"),
                                        content: const Text(
                                            "Supprimer le modèle de jeu?",
                                            style: TextStyle(fontSize: 20)),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                Flushbar(
                                                        title: "État",
                                                        message:
                                                            "Suppression en cours...",
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                        flushbarStyle:
                                                            FlushbarStyle
                                                                .FLOATING)
                                                    .show(context);
                                                await ref.watch(
                                                    removeTemplateProvider(
                                                            currentTemplate)
                                                        .future);
                                                ref.invalidate(
                                                    getAllTemplatesProvider);
                                                // rmeove
                                              },
                                              child: const Text("oui")),
                                          TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("non")),
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(Icons.cancel)),
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
      return Material(
        child: Center(
            child: Column(children: [
          const Text(
              "Échec du chargement de toutes les configurations, vérifiez la connexion à la base de données"),
          const SizedBox(
            height: 30,
          ),
          IconButton(
              onPressed: () {
                ref.invalidate(getAllTemplatesProvider);
              },
              icon: Icon(
                Icons.refresh,
                size: 48,
              ))
        ])),
      );
    }, loading: () {
      return const Center(child: CircularProgressIndicator.adaptive());
    });
  }
}

class _ConfigAdd extends ConsumerWidget {
  _ConfigAdd({this.template});
  final GameTemplate? template;
  final _letterEditingController = TextEditingController();
  final _focusNode = FocusNode();

  final List<GlobalKey> _keys = List.generate(25, (index) => GlobalKey());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        persistentFooterButtons: [
          ElevatedButton(
              onPressed: () async {
                var lettersStatus = ref.watch(_isDtlMode)
                    ? ref.watch(_listOfLettersProvider).isEmpty
                    : ref.watch(_listOfLettersProvider).isNotEmpty;
                if (ref.watch(templateNameProvider).isEmpty || !lettersStatus) {
                  await Flushbar(
                          flushbarPosition: FlushbarPosition.TOP,
                          title: "Error",
                          message: "Check name or letters",
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.redAccent.shade100,
                          flushbarStyle: FlushbarStyle.FLOATING)
                      .show(context);
                  return;
                }
                Flushbar(
                        title: "État",
                        duration: const Duration(seconds: 1),
                        flushbarPosition: FlushbarPosition.TOP,
                        message: "Sauvegarde en cours...:",
                        flushbarStyle: FlushbarStyle.FLOATING)
                    .show(context);
                final letters = ref.watch(_isDtlMode)
                    ? List.generate(25, (index) => " ")
                    : ref.watch(_listOfLettersProvider).values.toList();
                final status = await ref.watch(addTemplateProvider(GameTemplate(
                        id: const Uuid().v4(),
                        name: ref.watch(templateNameProvider),
                        compak: ref.watch(_isCompakMode),
                        letters: letters,
                        playerMovements:
                            ref.watch(listOfPlayerMovementProvider),
                        doubleIndexes: ref.watch(listOfDoubleShotsProvider),
                        dtl: ref.watch(_isDtlMode)))
                    .future);
                if (context.mounted) {
                  if (status) {
                    await Flushbar(
                            flushbarPosition: FlushbarPosition.TOP,
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
                      hintText: 'Entrez le nom du template',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )))),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              // controller: _ballsController,
              // scrollDirection: Axis.horizontal,
              child: ref.watch(_isCompakMode)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          ...List.generate(25, (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 3.0,
                                  top: 3.0,
                                  bottom: 3.0,
                                  right: (index + 1) % 5 == 0 ? 25 : 3.0),
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: GestureDetector(
                                    key: _keys[index],
                                    onTap: () {
                                      ref
                                          .watch(
                                              _selectedCircleProvider.notifier)
                                          .state = index;
                                      _letterEditingController.text = '';
                                    },
                                    child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: ref.watch(
                                                        _selectedCircleProvider) ==
                                                    index
                                                ? Colors.deepPurple
                                                : Colors.green,
                                            shape: BoxShape.circle),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                                ref.watch(_listOfLettersProvider)[
                                                        index] ??
                                                    "-",
                                                style: const TextStyle(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                        ))),
                              ),
                            );
                          })
                        ])
                  : Scrollbar(
                      interactive: true,
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          ...List.generate(25, (index) {
                            if (ref
                                .watch(listOfDoubleShotsProvider)
                                .contains(index - 1)) {
                              return Container();
                            }
                            if (ref
                                .watch(listOfDoubleShotsProvider)
                                .contains(index)) {
                              // if it contains the number
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: GestureDetector(
                                              key: _keys[index],
                                              onTap: () {
                                                ref
                                                    .watch(
                                                        _selectedCircleProvider
                                                            .notifier)
                                                    .state = index;
                                                _letterEditingController.text =
                                                    '';
                                              },
                                              child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                      color: ref.watch(
                                                                  _selectedCircleProvider) ==
                                                              index
                                                          ? Colors.deepPurple
                                                          : Colors.green,
                                                      shape: BoxShape.circle),
                                                  child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text(
                                                        ref.watch(_listOfLettersProvider)[
                                                                index] ??
                                                            "-",
                                                        style: const TextStyle(
                                                            fontSize: 40,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
                                                  ))),
                                        ),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: GestureDetector(
                                              key: _keys[index + 1],
                                              onTap: () {
                                                ref
                                                    .watch(
                                                        _selectedCircleProvider
                                                            .notifier)
                                                    .state = index + 1;
                                                _letterEditingController.text =
                                                    '';
                                              },
                                              child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                      color: ref.watch(
                                                                  _selectedCircleProvider) ==
                                                              index + 1
                                                          ? Colors.deepPurple
                                                          : Colors.green,
                                                      shape: BoxShape.circle),
                                                  child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text(
                                                        ref.watch(_listOfLettersProvider)[
                                                                index + 1] ??
                                                            "-",
                                                        style: const TextStyle(
                                                            fontSize: 40,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
                                                  ))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 3.0,
                                right: ref
                                        .watch(listOfPlayerMovementProvider)
                                        .contains(index)
                                    ? 20
                                    : 3.0,
                                top: 3,
                                bottom: 3,
                              ),
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: GestureDetector(
                                    key: _keys[index],
                                    onTap: () {
                                      ref
                                          .watch(
                                              _selectedCircleProvider.notifier)
                                          .state = index;
                                      _letterEditingController.text = '';
                                    },
                                    child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: ref.watch(
                                                        _selectedCircleProvider) ==
                                                    index
                                                ? Colors.deepPurple
                                                : ref
                                                        .watch(
                                                            listOfPlayerMovementProvider)
                                                        .contains(index)
                                                    ? Colors.amber
                                                    : Colors.green,
                                            shape: BoxShape.circle),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                                ref.watch(_listOfLettersProvider)[
                                                        index] ??
                                                    "-",
                                                style: const TextStyle(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                        ))),
                              ),
                            );
                          })
                        ]),
                      ),
                    )),
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: TextButton(
                  onPressed: () async {
                    ref.watch(_selectedCircleProvider.notifier).update(
                        (state) => state != null && state > 0 ? state - 1 : 0);
                    await Scrollable.ensureVisible(
                        _keys[ref.watch(_selectedCircleProvider) ?? 0]
                                .currentContext ??
                            context,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: const Text("previous")),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: TextButton(
                  onPressed: () async {
                    ref.watch(_selectedCircleProvider.notifier).update(
                        (state) => state != null &&
                                state < (ref.watch(_isCompakMode) ? 24 : 24)
                            ? state + 1
                            : 0);
                    await Scrollable.ensureVisible(
                      _keys[ref.watch(_selectedCircleProvider) ??
                                  (ref.watch(_isCompakMode) ? 24 : 24)]
                              .currentContext ??
                          context,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  child: const Text("next")),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: TextButton(
                  onPressed: () {
                    if (ref.watch(_isDtlMode)) {
                      return;
                    }
                    Map<int, String> a = {};
                    final letters =
                        '123456789abcdefghijklmnopq'.toUpperCase().split('');
                    for (var i = 0; i < letters.length; i++) {
                      a.addAll({i: letters[i]});
                    }
                    letters.map((e) => {letters.indexOf(e): e});
                    ref.watch(_listOfLettersProvider.notifier).state = a;
                  },
                  child: const Text("Auto-fill")),
            )
          ]),
          ref.watch(_selectedCircleProvider) != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (submission) {
                      ref
                          .watch(_listOfLettersProvider.notifier)
                          .update((state) {
                        state[ref.watch(_selectedCircleProvider) ?? 0] =
                            submission
                                .toString()
                                .characters
                                .first
                                .toUpperCase();
                        return state;
                      });
                      _letterEditingController.text = "";
                      ref.watch(_selectedCircleProvider.notifier).update(
                          (state) => state != null &&
                                  state < (ref.watch(_isCompakMode) ? 24 : 24)
                              ? state + 1
                              : 0);
                      _focusNode.requestFocus();
                    },
                    controller: _letterEditingController,
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
                                title: const Text("Coup double?"),
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
                    !ref
                            .watch(listOfDoubleShotsProvider)
                            .contains(ref.watch(_selectedCircleProvider))
                        ? SizedBox(
                            height: 75,
                            width: MediaQuery.of(context).size.width * .5,
                            child: Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SwitchListTile(
                                      title: const Text("Changement de tireur?"),
                                      value: ref
                                          .watch(listOfPlayerMovementProvider)
                                          .contains(ref
                                              .watch(_selectedCircleProvider)),
                                      onChanged: (switched) {
                                        if (switched) {
                                          ref
                                              .watch(
                                                  listOfPlayerMovementProvider
                                                      .notifier)
                                              .update((state) {
                                            state.add(ref.watch(
                                                    _selectedCircleProvider) ??
                                                0);
                                            state = [...state];
                                            return state;
                                          });
                                        } else {
                                          ref
                                              .watch(
                                                  listOfPlayerMovementProvider
                                                      .notifier)
                                              .update((state) {
                                            state.remove(ref.watch(
                                                    _selectedCircleProvider) ??
                                                0);
                                            state = [...state];
                                            return state;
                                          });
                                        }
                                      })),
                            ),
                          )
                        : Container(),
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
                        if (switched) {
                          ref.watch(_isCompakMode.notifier).state = false;
                          ref.watch(_listOfLettersProvider.notifier).state = {};
                        }
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
                            if (switched) {
                              ref.watch(_isDtlMode.notifier).state = false;
                            }
                            ref.watch(_listOfLettersProvider.notifier).state =
                                {};
                          }))))
        ])));
  }
}

final templateNameProvider = StateProvider((ref) => '');
final listOfDoubleShotsProvider =
    StateProvider.autoDispose<List<int>>((ref) => []);
final listOfPlayerMovementProvider =
    StateProvider.autoDispose<List<int>>((ref) => []);
final _listOfLettersProvider =
    StateProvider.autoDispose<Map<int, String>>((ref) => {});
final _selectedCircleProvider = StateProvider.autoDispose<int?>((ref) => null);
final _isDtlMode = StateProvider.autoDispose((ref) => false);
final _isCompakMode = StateProvider.autoDispose((ref) => false);

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
                    title: const Text("nom", style: TextStyle(fontSize: 24)),
                    subtitle: Text(template.name))),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ...List.generate(25, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 3.0,
                          top: 8,
                          bottom: 8,
                          right:
                              template.compak && (index + 1) % 5 == 0 ? 30 : 3),
                      child: SizedBox(
                        width: 35,
                        height: 35,
                        child: GestureDetector(
                          onTap: () {
                            ref.watch(_selectedCircleProvider.notifier).state =
                                index;
                          },
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: ref.watch(_selectedCircleProvider) ==
                                          index
                                      ? Colors.deepPurple
                                      : Colors.green,
                                  shape: BoxShape.circle),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  template.letters[index],
                                  style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )),
                        ),
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
                                    title: const Text("doublé?"),
                                    subtitle: template.doubleIndexes.contains(
                                            ref.watch(_selectedCircleProvider))
                                        ? const Text("oui")
                                        : const Text("non"),
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
                        title: const Text('Nombre de changements de joueur'),
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
                          subtitle: template.dtl
                              ? const Text("oui")
                              : const Text("non"),
                        )))),
            const SizedBox(height: 12),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 65)),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return TemplateStats(template: template);
                      }));
                    },
                    child: const Text("Statistiques")))
          ]),
        )));
  }
}


