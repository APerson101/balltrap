import 'package:balltrap/models/game_template.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameConfig extends ConsumerWidget {
  const GameConfig({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListTile(
              title: const Text("Add new Configuration"),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const _ConfigAdd();
                }));
              }),
          ...List.generate(ref.watch(allTemplatesProvider).length, (index) {
            var currentTemplate = ref.watch(allTemplatesProvider)[index];
            return ListTile(
              title: Text(currentTemplate.name),
              trailing: IconButton(
                  onPressed: () {
                    // remove from list
                    ref.watch(allTemplatesProvider.notifier).update((state) {
                      state.removeAt(index);
                      state = [...state];
                      return state;
                    });
                  },
                  icon: const Icon(Icons.cancel)),
              subtitle: Text(currentTemplate.doubleIndexes.join(', ')),
            );
          })
        ],
      ),
    );
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
                        hintText: 'Enter template Name',
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
                        hintText: 'number of double shots',
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

                        print(
                            "double shot would occur at the following indexes: ${ref.watch(indexOfDoubleShotsProvider)}");
                      },
                      decoration: InputDecoration(
                          hintText: 'occurence ${index + 1}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ))));
            }),
            ElevatedButton(
                onPressed: () {
                  ref.watch(allTemplatesProvider.notifier).update((state) {
                    state.add(GameTemplate(
                        name: ref.read(templateNameProvider),
                        doubleIndexes: ref
                            .read(indexOfDoubleShotsProvider)
                            .values
                            .toList()));
                    state = [...state];
                    return state;
                  });
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 65)),
                child: const Text("Save"))
          ],
        ));
  }
}

final templateNameProvider = StateProvider((ref) => '');
final doubleShotOccurenceProvider = StateProvider((ref) => 0);
final indexOfDoubleShotsProvider = StateProvider<Map<int, int>>((ref) => {});
final allTemplatesProvider = StateProvider<List<GameTemplate>>((ref) => []);
