import 'package:arvya_app/data/repositories/ambience_repository.dart';
import 'package:arvya_app/features/ambience/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final repo = AmbienceRepository();
    repo.loadAmbiences().then((data) {
      print(data[0].title);
    });
    return MaterialApp(title: 'Flutter Demo', home: HomeScreen());
  }
}
