import 'package:balltrap/admin/admin_home.dart';
import 'package:balltrap/admin/stats_by_template.dart';
import 'package:balltrap/admin/sidebar.dart';
import 'package:balltrap/admin/stats_by_player.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminView extends ConsumerWidget {
  const AdminView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Positioned(
            left: 10,
            top: 10,
            bottom: 10,
            width: MediaQuery.of(context).size.width * .2,
            child: const SideBar(),
          ),
          Positioned(
              right: 10,
              top: 10,
              bottom: 10,
              width: MediaQuery.of(context).size.width * .7,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(20)),
                  child: ref.watch(selectedViewProvider) == SideMenu.summary
                      ? const SummaryView()
                      : ref.watch(selectedViewProvider) == SideMenu.stats
                          ? const TemplateStats()
                          : const PlayerStats()))

        ]),
      ),
    );
  }
}
