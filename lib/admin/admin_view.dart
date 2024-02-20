import 'package:balltrap/admin/admin_home.dart';
import 'package:balltrap/admin/admin_tablet.dart';
import 'package:balltrap/admin/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminView extends ConsumerWidget {
  const AdminView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(children: [
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
            child: ref.watch(selectedViewProvider) == SideMenu.summary
                ? const SummaryView()
                : TabletView(
                    tablet: switch (ref.watch(selectedViewProvider)) {
                    SideMenu.tablet1 => 1,
                    SideMenu.tablet2 => 2,
                    SideMenu.tablet3 => 3,
                    _ => 4
                  })),
      ]),
    );
  }
}
