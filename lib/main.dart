import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: StreetFoodFinderApp(),
    ),
  );
}

class StreetFoodFinderApp extends StatelessWidget {
  const StreetFoodFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Street Food Finder',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}