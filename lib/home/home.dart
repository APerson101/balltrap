import 'package:balltrap/home/addplayers.dart';
import 'package:balltrap/models/event.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
              child: Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const AddPlayers();
                        }));
                      },
                      child: const Text("New game"))
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     ...ref.watch(eventsListProvider).map((item) {
                  //       return Card(
                  //           child: ListTile(
                  //               onTap: () {
                  //                 Navigator.of(context)
                  //                     .push(MaterialPageRoute(builder: ((context) {
                  //                   return EventDetails(item: item);
                  //                 })));
                  //               },
                  //               title: Text(item.title),
                  //               subtitle: Text(item.date),
                  //               trailing: Text(item.location)));
                  //     }).toList(),

                  //   ],
                  // ),
                  )),
        ),
      ),
    );
  }
}

final notesProvider = StateProvider<String>((ref) => '');
final titleProvider = StateProvider<String>((ref) => '');
final locationProvider = StateProvider<String>((ref) => '');
final eventsListProvider = StateProvider<List<EventType>>((ref) => []);
