import 'package:another_flushbar/flushbar.dart';
import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/models/player_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlayerDetails extends ConsumerWidget {
  const AddPlayerDetails({super.key, this.player});
  final PlayerDetails? player;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                initialValue: player?.name,
                onChanged: (name) {
                  ref.watch(_nameFieldProvider.notifier).state = name;
                },
                decoration: InputDecoration(
                    hintText: "Enter name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                initialValue: player?.subscriptionsLeft.toString(),
                onChanged: (subs) {
                  ref.watch(_subscriptionsLeftProvider.notifier).state =
                      int.parse(subs);
                },
                decoration: InputDecoration(
                    hintText: "Enter number of subscriptions left",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                initialValue: player?.id,
                onChanged: (id) {
                  ref.watch(_idFieldProvider.notifier).state = id;
                },
                decoration: InputDecoration(
                    hintText: "Type Tag ID or scan ID",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
// save details and move forward
                  final status = await ref.watch(savePlayerDetailsProvider(
                          PlayerDetails(
                              id: ref.watch(_idFieldProvider),
                              name: ref.watch(_nameFieldProvider),
                              subscriptionsLeft:
                                  ref.watch(_subscriptionsLeftProvider)))
                      .future);

                  if (status) {
                    Flushbar(
                            title: "Etat",
                            message: "Successfully saved the player to the DB",
                            duration: const Duration(seconds: 3),
                            flushbarStyle: FlushbarStyle.FLOATING)
                        .show(context);
                  } else {
                    Flushbar(
                            title: "Etat",
                            message: "Failed to save the player to the DB",
                            duration: const Duration(seconds: 3),
                            flushbarStyle: FlushbarStyle.FLOATING)
                        .show(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 65)),
                child: const Text("Save")),
          )
        ])));
  }
}

final _nameFieldProvider = StateProvider((ref) => "");
final _idFieldProvider = StateProvider((ref) => "");
final _subscriptionsLeftProvider = StateProvider<int>((ref) => 0);
