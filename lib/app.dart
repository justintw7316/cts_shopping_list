import 'package:flutter/material.dart';

import 'features/shopping/view/shopping_page.dart';

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color.fromARGB(255, 42, 175, 190);
    
    return MaterialApp(
      title: "Shopping List 🛍️",
      theme: ThemeData (
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F4F2),
        useMaterial3: true,
      ),
      home: const ShoppingPage(),
    );
  }
}