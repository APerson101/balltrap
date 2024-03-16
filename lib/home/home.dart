import 'package:balltrap/admin/admin_home.dart';
import 'package:balltrap/admin/admin_provider.dart';
import 'package:balltrap/home/addplayers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Color(0xffd37676)),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewIP(
                      includeId: true,
                    )));
          },
        )
      ]),
      body: SafeArea(
          child: ref.watch(_loadAnimationProvider).when(
              data: (lottie) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie(composition: lottie),
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple.shade50,
                                  minimumSize: const Size(double.infinity, 65)),
                              onPressed: () async {
                                var list = await ref
                                    .watch(getAllPlayersProvider.future);

                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return AddPlayers(players: list);
                                }));
                              },
                              child: Text(
                                  "Démarrer une nouvelle partie !"
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                        ))
                      ]),
                );
              },
              error: (er, st) {
                debugPrintStack(stackTrace: st);
                return const Center(child: Text("Error"));
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()))),
    );
  }
}

final _loadAnimationProvider = FutureProvider(
    (ref) => AssetLottie('assets/animations/welcome.json').load());
