import 'package:balltrap/admin/player_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerStats extends ConsumerWidget {
  const PlayerStats({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (name) {
                ref.watch(_playerNameProvider.notifier).state = name;
              },
              decoration: InputDecoration(
                  suffix: IconButton(
                      onPressed: () async {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PlayerSearchResult(
                              playerName: ref.watch(_playerNameProvider));
                        }));
                      },
                      icon: const Icon(Icons.search)),
                  hintText: 'search for player',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          )
        ],
      )),
    );
  }
}

final _playerNameProvider = StateProvider.autoDispose<String>((ref) => '');
