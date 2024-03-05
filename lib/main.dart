// ignore: unused_import
import 'package:balltrap/admin/admin_view.dart';
// ignore: unused_import
import 'package:balltrap/home/home.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'Ball Trap App',
=======
      title: 'Flutter Demo',
>>>>>>> 0ad9c91a21d60e010fbebb6e1592775eb7bb7364
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const AdminView(),
      home: const HomeView(),
    );
  }
}
