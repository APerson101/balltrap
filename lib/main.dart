// ignore: unused_import
import 'package:balltrap/admin/admin_view.dart';
// ignore: unused_import

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
    DateTime targetDate=DateTime(2024,8,15);
    DateTime now=DateTime.now();
    DateTime today=DateTime.utc(now.year,now.month,now.day);
    if (today.isBefore(targetDate)){
    return MaterialApp(
      title: 'balltrap ASTAC Ger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(211, 118, 118, 1)),
        useMaterial3: true,
      ),
   home: const AdminView(),
   //       home: const HomeView(),
    );
  }else{
      return MaterialApp();
    }
  }
}
