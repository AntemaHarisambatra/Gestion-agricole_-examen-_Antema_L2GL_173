import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/farm_provider.dart';
import 'screens/farm_screens.dart';

void main() {
  runApp(const FarmApp());
}

class FarmApp extends StatelessWidget {
  const FarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FarmProvider(),
      child: MaterialApp(
        title: 'Gestion agricole',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          scaffoldBackgroundColor: const Color(0xFFF4F8F1),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
