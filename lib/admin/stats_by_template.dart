import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/admin/game_config.dart';
class TemplateStats extends ConsumerWidget {
  const TemplateStats({super.key});
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
                  ...allTemplates.map((currentTemplate) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ViewTemplate(template: currentTemplate);
                            }));
                          },
                          leading: Text(
                              '${allTemplates.indexOf(currentTemplate) + 1}'),
                          title: Text(currentTemplate.name),
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
                  icon: const Icon(
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
