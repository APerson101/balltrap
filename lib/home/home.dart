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
    return ref.watch(getAllPlayersProvider).when(data: (players) {
      return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xffd37676)),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewIP(
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
                                    minimumSize:
                                        const Size(double.infinity, 65)),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return AddPlayers(players: players);
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
    }, loading: () {
      return Scaffold(
          appBar: AppBar(actions: [
            IconButton(
                icon: const Icon(Icons.settings, color: Color(0xffd37676)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NewIP(includeId: true)));
                })
          ]),
          body: const Material(
              child: Center(child: CircularProgressIndicator.adaptive())));
    }, error: (er, st) {
      return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xffd37676)),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewIP(
                        includeId: true,
                      )));
            },
          )
        ]),
        body: Material(
          child: Column(
            children: [
              const Center(child: Text("Failed to load the players data")),
              IconButton(
                  onPressed: () {
                    ref.invalidate(getAllPlayersProvider);
                  },
                  icon: const Icon(Icons.refresh, size: 48))
            ],
          ),
        ),
      );
    });
  }
}

final _loadAnimationProvider = FutureProvider(
    (ref) => AssetLottie('assets/animations/welcome.json').load());
