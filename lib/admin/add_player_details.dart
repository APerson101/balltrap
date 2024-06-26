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
                  if (player == null) {
                    ref.watch(_nameFieldProvider.notifier).state = name;
                  } else {
                    player!.name = name;
                  }
                },
                decoration: InputDecoration(
                    hintText: "Nom du joueur",
                    labelText: "Nom du joueur",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                initialValue: player?.subscriptionsLeft.toString(),
                onChanged: (subs) {
                  if (player == null) {
                    ref.watch(_subscriptionsLeftProvider.notifier).state =
                        int.parse(subs);
                  } else {
                    player!.subscriptionsLeft = int.parse(subs);
                  }
                },
                decoration: InputDecoration(
                    labelText: "Nombre de crédits disponibles",
                    hintText: "Entrez le nombre de crédits disponibles",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                initialValue: player?.id,
                onChanged: (id) {
                  if (player == null) {
                    ref.watch(_idFieldProvider.notifier).state = id;
                  } else {
                    ref.watch(_newidFieldProvider.notifier).state = id;
                  }
                },
                decoration: InputDecoration(
                    labelText: "l'identifiant",
                    hintText: "l'identifiant",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
// save details and move forward
                  bool status;
                  if (player == null) {
                    status = await ref.watch(savePlayerDetailsProvider(
                            PlayerDetails(
                                id: ref.watch(_idFieldProvider),
                                name: ref.watch(_nameFieldProvider),
                                subscriptionsLeft:
                                    ref.watch(_subscriptionsLeftProvider)))
                        .future);
                  } else {
                    status = await ref.watch(updatePlayerDetailsProvider(
                            player!, ref.watch(_newidFieldProvider))
                        .future);
                  }
                  ref.invalidate(getAllPlayersProvider);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  if (status && context.mounted) {
                    Flushbar(
                            title: "Etat",
                            message: "Succès",
                            duration: const Duration(seconds: 3),
                            flushbarStyle: FlushbarStyle.FLOATING)
                        .show(context);
                  } else if (context.mounted) {
                    Flushbar(
                            title: "Etat",
                            message: "Échec de la sauvegarde dans la base",
                            duration: const Duration(seconds: 3),
                            flushbarStyle: FlushbarStyle.FLOATING)
                        .show(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 65)),
                child: const Text("Sauver")),
          )
        ])));
  }
}

final _nameFieldProvider = StateProvider.autoDispose((ref) => "");
final _idFieldProvider = StateProvider.autoDispose((ref) => "");
final _subscriptionsLeftProvider = StateProvider.autoDispose<int>((ref) => 0);
final _newidFieldProvider = StateProvider.autoDispose<String?>((ref) => null);
