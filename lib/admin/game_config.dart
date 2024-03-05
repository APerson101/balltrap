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
                            return const _ConfigAdd();
                          }));
                        }),
                  ),
                  const Divider(),
                  ...allTemplates.map((currentTemplate) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
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
  const _ConfigAdd();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    onChanged: (templateName) {
                      ref.watch(templateNameProvider.notifier).state =
                          templateName;
                    },
                    decoration: InputDecoration(
                        hintText: 'Entrez le nom du modèle',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )))),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    onChanged: (doubleShotOccurence) {
                      ref.watch(doubleShotOccurenceProvider.notifier).state =
                          int.parse(doubleShotOccurence);
                    },
                    decoration: InputDecoration(
                        hintText: 'Nombre de doubles coups',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )))),
            ...List.generate(ref.watch(doubleShotOccurenceProvider), (index) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      onChanged: (doubleIndex) {
                        ref
                            .watch(indexOfDoubleShotsProvider.notifier)
                            .update((state) {
                          state[index] = int.parse(doubleIndex);
                          return state;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: 'Position ${index + 1}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ))));
            }),
            ElevatedButton(
                onPressed: () async {
                  Flushbar(
                          title: "État",
                          message: "Sauvegarde en cours...:",
                          flushbarStyle: FlushbarStyle.FLOATING)
                      .show(context);
                  final status = await ref.watch(addTemplateProvider(
                          GameTemplate(
                              id: const Uuid().v4(),
                              name: ref.watch(templateNameProvider),
                              doubleIndexes: ref
                                  .watch(indexOfDoubleShotsProvider)
                                  .values
                                  .toList()))
                      .future);
                  if (context.mounted) {
                    if (status) {
                      await Flushbar(
                              title: "État",
                              message:
                                  "Ajouté avec succès à la base de données",
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
        ));
  }
}

final templateNameProvider = StateProvider((ref) => '');
final doubleShotOccurenceProvider = StateProvider((ref) => 0);
final indexOfDoubleShotsProvider = StateProvider<Map<int, int>>((ref) => {});
