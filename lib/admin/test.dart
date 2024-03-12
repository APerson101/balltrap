import 'package:balltrap/admin/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestView extends ConsumerWidget {
  const TestView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        body: ref.watch(testProvider).when(
            data: (data) {
              return const SingleChildScrollView(
                child: Column(
                  children: [
                    // ...data.map((player) => Center(child: Text(player.name))),
                  ],
                ),
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (er, st) {
              debugPrintStack(stackTrace: st);
              return const Center(
                child: Text("error"),
              );
            }));
  }
}
