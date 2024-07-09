import 'package:balltrap/admin/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SideBar extends ConsumerWidget {
  const SideBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...SideMenu.values.map((menuItem) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      leading: Icon(menuItem.icon),
                      title: Text(menuItem.label),
                      tileColor: ref.watch(selectedViewProvider) == menuItem
                          ? Colors.green[400]
                          : null,
                      onTap: () {
                        ref.watch(selectedViewProvider.notifier).state =
                            menuItem;
                      }));
            }).toList(),
            IconButton(
                onPressed: () async {
                  ref.invalidate(allSessionsProvider);
                   ref.invalidate(getAllPlayersProvider);
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
      ),
    );
  }
}

enum SideMenu {
  summary(label: "Accueil", icon: FontAwesomeIcons.gauge),
  // tablet1(label: "Tablet 1", icon: FontAwesomeIcons.one),
  // tablet2(label: "Tablet 2", icon: FontAwesomeIcons.two),
  // tablet3(label: "Tablet 3", icon: FontAwesomeIcons.three),
  stats(label: "Statistiques par joueur", icon: FontAwesomeIcons.chartBar),
  statsByTemplate(label: "Statistiques par template", icon: FontAwesomeIcons.chartBar);

  final String label;
  final IconData icon;
  const SideMenu({required this.label, required this.icon});
}

final selectedViewProvider = StateProvider((ref) => SideMenu.summary);
